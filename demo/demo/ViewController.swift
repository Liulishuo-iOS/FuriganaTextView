//
//  ViewController.swift
//  demo
//
//  Created by Yan Li on 5/12/15.
//  Copyright (c) 2015 Liulishuo.com. All rights reserved.
//

import UIKit

class ViewController: UIViewController
{

  @IBOutlet weak var textView: FuriganaTextView!
  
  override func viewDidLoad()
  {
    super.viewDidLoad()
    
    textView.furiganas = exampleFuriganas
    textView.contents = exampleContents
  }

}


// MARK: - Example Contents Mock

extension ViewController
{
  
  private var exampleFuriganas: [Furigana] {
    return [
      // Furiganas for '田中さん、中華料理を食べたことありますか。'
      Furigana(text: "た", original: "田", range: NSMakeRange(0, 1)),
      Furigana(text: "なか", original: "中", range: NSMakeRange(1, 1)),
      Furigana(text: "ちゅう", original: "中", range: NSMakeRange(5, 1)),
      Furigana(text: "か", original: "華", range: NSMakeRange(6, 1)),
      Furigana(text: "りょう", original: "料", range: NSMakeRange(7, 1)),
      Furigana(text: "り", original: "理", range: NSMakeRange(8, 1)),
      Furigana(text: "た", original: "食", range: NSMakeRange(10, 1)),
      
      // Furiganas for 'すみません。靴売り場はどこですか。'
      Furigana(text: "くつ", original: "靴", range: NSMakeRange(29, 1)),
      Furigana(text: "う", original: "売", range: NSMakeRange(30, 1)),
      Furigana(text: "ば", original: "場", range: NSMakeRange(32, 1)),
      
      // Furiganas for 'サーモン刺身。狐、哺乳綱ネコ目（食肉目）イヌ科イヌ亜科の一部。'
      Furigana(text: "きつね", original: "狐", range: NSMakeRange(59, 1)),
      Furigana(text: "さしみ", original: "刺身", range: NSMakeRange(91, 2)),
      Furigana(text: "め", original: "目", range: NSMakeRange(93, 1)),
    ]
  }
  
  // Because we are using NSAttributedString as contents,
  // most builtin attributes (e.g. NSFontAttributeName, NSForegroundColorAttributeName) will work just fine.
  private var exampleContents: NSAttributedString {
    let contents = NSMutableAttributedString(string: "田中さん、中華料理を食べたことありますか。\n\n", attributes: [NSFontAttributeName : exampleFont])
    contents.addAttribute(NSForegroundColorAttributeName, value: UIColor.darkGrayColor(), range: NSMakeRange(0, 2))
    contents.addAttribute(NSForegroundColorAttributeName, value: UIColor.redColor(), range: NSMakeRange(5, 2))
    contents.addAttribute(NSForegroundColorAttributeName, value: UIColor.brownColor(), range: NSMakeRange(7, 2))
    contents.addAttribute(NSForegroundColorAttributeName, value: UIColor.greenColor(), range: NSMakeRange(10, 1))
    
    contents.appendAttributedString(NSAttributedString(string: "すみません。靴売り場はどこですか。\n\n", attributes: [NSFontAttributeName : exampleFontSansSerif]))
    contents.addAttribute(NSForegroundColorAttributeName, value: UIColor.purpleColor(), range: NSMakeRange(29, 1))
    contents.addAttribute(NSForegroundColorAttributeName, value: UIColor.orangeColor(), range: NSMakeRange(30, 3))
    
    contents.appendAttributedString(NSAttributedString(string: "サーモン刺身、哺乳綱ネコ目（食肉目狐）イヌ科イヌ亜科の一部。\n\n", attributes: [NSFontAttributeName : exampleFont]))
    contents.addAttribute(NSForegroundColorAttributeName, value: UIColor.orangeColor(), range: NSMakeRange(59, 1))
    
    contents.appendAttributedString(NSAttributedString(string: "サーモン刺身狐、哺乳綱ネコ目（食肉刺身目）イヌ科イヌ亜科の一部。", attributes: [NSFontAttributeName : exampleFont]))
    contents.addAttribute(NSForegroundColorAttributeName, value: UIColor.redColor(), range: NSMakeRange(91, 2))
    
    return contents;
  }
  
  private var exampleFont: UIFont {
    return UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
  }
  
  private var exampleFontSansSerif: UIFont {
    let fontDescriptor = UIFontDescriptor(name: "Hiragino Kaku Gothic ProN", size: 24)
    return UIFont(descriptor: fontDescriptor, size: 24)
  }
  
}
