//
//  FuriganaWordKerner.swift
//  Tydus
//
//  Created by Yan Li on 4/1/15.
//  Copyright (c) 2015 Liulishuo.com. All rights reserved.
//

import UIKit

class FuriganaWordKerner: NSObject, NSLayoutManagerDelegate
{
  
  // MARK: - NSLayoutManager Delegate
  
  func layoutManager(layoutManager: NSLayoutManager, shouldGenerateGlyphs glyphs: UnsafePointer<CGGlyph>, properties props: UnsafePointer<NSGlyphProperty>, characterIndexes charIndexes: UnsafePointer<Int>, font aFont: UIFont, forGlyphRange glyphRange: NSRange) -> Int
  {
    let glyphCount = glyphRange.length
    let textStorageString = layoutManager.textStorage!.string as NSString
    var newProps: UnsafeMutablePointer<NSGlyphProperty> = nil
    
    for i in 0..<glyphCount
    {
      let charIndex = charIndexes[i]
      if let _ = layoutManager.textStorage!.attribute(kFuriganaAttributeName, atIndex: charIndex, effectiveRange: nil) as? NSString
      {
        if textStorageString.substringAtIndex(charIndex) == kDefaultFuriganaKerningControlCharacter
        {
          if newProps == nil
          {
            let memSize = Int(sizeof(NSGlyphProperty) * glyphCount)
            newProps = unsafeBitCast(malloc(memSize), UnsafeMutablePointer<NSGlyphProperty>.self)
            memcpy(newProps, props, memSize)
          }
          
          newProps[i] = .ControlCharacter
        }
      }
    }
    
    if newProps != nil
    {
      layoutManager.setGlyphs(glyphs, properties: newProps, characterIndexes: charIndexes, font: aFont, forGlyphRange: glyphRange)
      free(newProps)
      return glyphCount
    }
    else
    {
      return 0
    }
  }
  
  func layoutManager(layoutManager: NSLayoutManager, shouldUseAction action: NSControlCharacterAction, forControlCharacterAtIndex charIndex: Int) -> NSControlCharacterAction
  {
    if layoutManager.textStorage!.attribute(kFuriganaAttributeName, atIndex: charIndex, effectiveRange: nil) != nil
    {
      return .Whitespace
    }
    
    return action
  }
 
  func layoutManager(layoutManager: NSLayoutManager, boundingBoxForControlGlyphAtIndex glyphIndex: Int, forTextContainer textContainer: NSTextContainer, proposedLineFragment proposedRect: CGRect, glyphPosition: CGPoint, characterIndex charIndex: Int) -> CGRect
  {
    var width: CGFloat = 0
    
    if let furiganaAttributeValue = layoutManager.textStorage?.attribute(kFuriganaAttributeName, atIndex: charIndex, effectiveRange: nil) as? NSString
    {
      if let furiganaText = FuriganaTextFromStringRepresentation(furiganaAttributeValue),
         let originalText = FuriganaOriginalTextFromStringrepresentation(furiganaAttributeValue)
      {
        let originalFont = layoutManager.textStorage!.attribute(NSFontAttributeName, atIndex: charIndex, effectiveRange: nil) as! UIFont
        let furiganaFont = originalFont.fontWithSize(originalFont.pointSize / kDefaultFuriganaFontMultiple)
        
        let originalWidth = originalText.sizeWithAttributes([NSFontAttributeName : originalFont]).width
        let furiganaWidth = furiganaText.sizeWithAttributes([NSFontAttributeName : furiganaFont]).width
        
        width = ceil((furiganaWidth - originalWidth) / 2)
        if width < 0
        {
          width = 0
        }
      }
    }
    
    return CGRectMake(glyphPosition.x, glyphPosition.y, width, CGRectGetHeight(proposedRect))
  }
  
  func layoutManager(layoutManager: NSLayoutManager, shouldBreakLineByWordBeforeCharacterAtIndex charIndex: Int) -> Bool
  {
    var longestEffectiveRange: NSRange = NSMakeRange(0, 0)
    if let textStorage = layoutManager.textStorage,
       let _ = textStorage.attribute(kFuriganaAttributeName, atIndex: charIndex, longestEffectiveRange: &longestEffectiveRange, inRange: NSMakeRange(0, textStorage.length)) as? NSString
    {
      return charIndex == longestEffectiveRange.location
    }
    else
    {
      return true
    }
  }
  
}
