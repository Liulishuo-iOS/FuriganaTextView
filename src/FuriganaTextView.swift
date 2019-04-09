//
//  FuriganaTextView.swift
//  Tydus
//
//  Created by Yan Li on 3/30/15.
//  Copyright (c) 2015 Liulishuo.com. All rights reserved.
//

import UIKit

public struct FuriganaTextStyle
{
  public let hostingLineHeightMultiple: CGFloat
  public let textOffsetMultiple: CGFloat
}

// MARK: - Base Class

open class FuriganaTextView: UIView
{
  
  // MARK: - Public
  
  public var contentView: UITextView? {
    return underlyingTextView
  }
  
  open var furiganaEnabled = true
  open var furiganaTextStyle = FuriganaTextStyle(hostingLineHeightMultiple: 1.6, textOffsetMultiple: 0)
  open var furiganas: [Furigana]?
  
  open var contents: NSAttributedString?
  {
    set
    {
      mutableContents = newValue?.mutableCopy() as? NSMutableAttributedString

      if furiganaEnabled
      {
        addFuriganaAttributes()
      }
      
      setup()
    }
    get
    {
      return mutableContents?.copy() as? NSAttributedString
    }
  }
  
  // MARK: - Private

  fileprivate var mutableContents: NSMutableAttributedString?
  fileprivate weak var underlyingTextView: UITextView?
  
  // [Yan Li]
  // A strong reference is needed, because NSLayoutManagerDelegate is unowned by the manager
  fileprivate var furiganaWordKerner: FuriganaWordKerner?
  
  fileprivate func setup()
  {
    underlyingTextView?.removeFromSuperview()
    
    if furiganaEnabled
    {
      setupFuriganaView()
    }
    else
    {
      setupRegularView()
    }
  }
  
  fileprivate func setupFuriganaView()
  {
    if let validContents = mutableContents
    {
      let layoutManager = FuriganaLayoutManager()
      layoutManager.textOffsetMultiple = furiganaTextStyle.textOffsetMultiple
      let kerner = FuriganaWordKerner()
      layoutManager.delegate = kerner
      
      let textContainer = NSTextContainer()
      layoutManager.addTextContainer(textContainer)
      
      let fullTextRange = NSMakeRange(0, (validContents.string as NSString).length)
      let paragrapStyle = NSMutableParagraphStyle()
      paragrapStyle.alignment = alignment
      paragrapStyle.lineHeightMultiple = furiganaTextStyle.hostingLineHeightMultiple
        validContents.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragrapStyle, range: fullTextRange)
      
      let textStorage = NSTextStorage(attributedString: validContents)
      textStorage.addLayoutManager(layoutManager)
      
      let textView = textViewWithTextContainer(textContainer)
      addSubview(textView)
      addConstraints(fullLayoutConstraints(textView))
      
      furiganaWordKerner = kerner
      underlyingTextView = textView
    }
  }
  
  fileprivate func setupRegularView()
  {
    if let validContents = mutableContents
    {
      let textView = textViewWithTextContainer(nil)
      textView.attributedText = validContents
      addSubview(textView)
      addConstraints(fullLayoutConstraints(textView))
      
      underlyingTextView = textView
    }
  }
  
  fileprivate func textViewWithTextContainer(_ textContainer: NSTextContainer?) -> UITextView
  {
    let textView = UITextView(frame: bounds, textContainer: textContainer)
    textView.isEditable = false
    textView.isScrollEnabled = scrollEnabled
    textView.alwaysBounceVertical = true
    textView.textContainerInset = .zero
    textView.textContainer.lineFragmentPadding = 0
    
    return textView
  }
  
  fileprivate func fullLayoutConstraints(_ view: UIView) -> [NSLayoutConstraint]
  {
    view.translatesAutoresizingMaskIntoConstraints = false
    
    let vertical = NSLayoutConstraint.constraints(
      withVisualFormat: "V:|-(0)-[view]-(0)-|",
      options: [],
      metrics: nil,
      views: ["view" : view])
    
    let horizontal = NSLayoutConstraint.constraints(
      withVisualFormat: "H:|-(0)-[view]-(0)-|",
      options: [],
      metrics: nil,
      views: ["view" : view])

    return vertical + horizontal
  }
  
  // MARK: - Deprecated
  
  @available(*, deprecated)
  open var scrollEnabled: Bool = true
  
  @available(*, deprecated)
  open var alignment: NSTextAlignment = .left
  
}

// MARK: - Furigana Handling

extension FuriganaTextView
{
  
  fileprivate func addFuriganaAttributes()
  {
    if let validContents = mutableContents
    {
      if let validFuriganas = furiganas
      {
        var inserted = 0
        for (_, furigana) in validFuriganas.enumerated()
        {
          var furiganaRange = furigana.range
          
          let furiganaValue = FuriganaStringRepresentation(furigana)
          let furiganaLength = (furigana.text as NSString).length
          let contentsLenght = furigana.range.length
          
          if furiganaLength > contentsLenght
          {
            let currentAttributes = validContents.attributes(at: furiganaRange.location + inserted, effectiveRange: nil)
            let kerningString = NSAttributedString(string: kDefaultFuriganaKerningControlCharacter, attributes: currentAttributes)
            
            let endLocation = furigana.range.location + furigana.range.length + inserted
            validContents.insert(kerningString, at: endLocation)
            
            let startLocation = furigana.range.location + inserted
            validContents.insert(kerningString, at: startLocation)
            
            let insertedLength = (kDefaultFuriganaKerningControlCharacter as NSString).length * 2
            inserted += insertedLength
            
            furiganaRange.location = startLocation
            furiganaRange.length += insertedLength
          }
          else
          {
            furiganaRange.location += inserted
          }
          
            validContents.addAttribute(NSAttributedString.Key.Furigana, value: furiganaValue, range: furiganaRange)
        }
        
        let fullTextRange = NSMakeRange(0, (validContents.string as NSString).length)
        validContents.fixAttributes(in: fullTextRange)
        mutableContents = validContents
      }      
    }
  }
  
}

// MARK: - Auto Layout

extension FuriganaTextView
{
  
  override open var intrinsicContentSize: CGSize
  {
    if let textView = underlyingTextView
    {
      let intrinsicSize = textView.sizeThatFits(CGSize(width: bounds.width, height: CGFloat.greatestFiniteMagnitude))
      
      // [Yan Li]
      // There is a time that we have to multiply the result by the line height multiple
      // to make it work, but it seems fine now.
      
      // intrinsicSize.height *= furiganaTextStyle.hostingLineHeightMultiple
      
      return intrinsicSize
    }
    else
    {
      return CGSize.zero
    }
  }
  
}
