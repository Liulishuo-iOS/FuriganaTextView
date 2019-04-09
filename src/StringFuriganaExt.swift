//
//  StringRubyAnnotationExt.swift
//  Tydus
//
//  Created by Yan Li on 3/30/15.
//  Copyright (c) 2015 Liulishuo.com. All rights reserved.
//

import Foundation

public struct Furigana
{
  public let text: String
  public let original: String
  public let range: NSRange
  public let UUID: Foundation.UUID = Foundation.UUID()
  
  public init(text: String, original: String, range: NSRange)
  {
    self.text = text
    self.original = original
    self.range = range
  }
}

extension NSAttributedString.Key {
    static let Furigana = NSAttributedString.Key(rawValue: "com.liulishuo.Furigana")
}

private let kFuriganaRepresentationFormatter = "|"

public func FuriganaStringRepresentation(_ furigana: Furigana) -> NSString
{
  let values: NSArray = [
    furigana.text,
    furigana.UUID.uuidString,
    furigana.original
  ]
  return values.componentsJoined(by: kFuriganaRepresentationFormatter) as NSString
}

public func FuriganaTextFromStringRepresentation(_ string: NSString) -> NSString?
{
  return string.components(separatedBy: kFuriganaRepresentationFormatter).first as NSString?
}

public func FuriganaOriginalTextFromStringrepresentation(_ string: NSString) -> NSString?
{
  return string.components(separatedBy: kFuriganaRepresentationFormatter).last as NSString?
}

private let kCharLength = 1

public extension NSString
{
  
    func substringAtIndex(_ index: Int) -> String
  {
    return substring(with: NSMakeRange(index, kCharLength))
  }

    func filteredString(_ predicateBlock: (NSString) -> Bool) -> NSString
  {
    var result = ""
    
    enumerateCharacters { (index, charString) -> Void in
      if predicateBlock(charString)
      {
        result += charString as String
      }
    }
    
    return result as NSString
  }
  
    func enumerateCharacters(_ enumeration: (Int, NSString) -> Void)
  {
    for i in 0..<length
    {
      enumeration(i, substringAtIndex(i) as NSString)
    }
  }
  
}
