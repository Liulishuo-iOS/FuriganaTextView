# FuriganaTextView

A simple wrapper view for UITextView that can display Furiganas.

[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

![Example](https://raw.githubusercontent.com/Liulishuo-iOS/FuriganaTextView/master/img/example.png)

## Install

### Install using Carthage

`FuriganaTextView` has been tested to work well with [Carthage](https://github.com/Carthage/Carthage). To install using Carthage:

1. First, you need to add `github "lingochamp/FuriganaTextView"` to your `Cartfile` .
2. When Carthage done building the frameworks, you will find a framework named `LLS.framework` contains the files needed for intergrating `FuriganaTextView` .
3. Drag `LLS.framework` into your project.
4. In the source file where you want to use `FuriganaTextView`, add `import LLS`, then you are ready to go.

#### Install Manually

Clone the repo then add all files inside `/src` into your project. 

Then you are ready to go.

## Usage

```swift

// Prepare furigana contents
// Note: The order of the furiganas provided to the FuriganaTextView is important.
// It must be ascending in manner of the location of the range,
// otherwise the furiganas may not be rendered at the correct position.
let furiganas = [
  Furigana(text: "た", original: "田", range: NSMakeRange(0, 1)),
  Furigana(text: "なか", original: "中", range: NSMakeRange(1, 1)),
]
let contents = NSAttributedString(string: "田中さん、中華料理を食べたことありますか。")

// Tell FuriganaTextView about 
// the furiganas (which is an array of the Furigana struct) 
// and the contents to display (a NSAttributedString)
furiganaTextView.furiganas = furiganas
furiganaTextView.contents = contents

// To customize the text view, use the contentView
// contentView will return a valid UITextView after
// the contents has been set
furiganaTextView.contentView?.backgroundColor = UIColor.lightGray

```

## Requirements

* Builds with __Xcode 10.2__ and __Swift 5__
* Supports __iOS 7 and above__

## Why not CTRubyAnnotation and CoreText

`FuriganaTextView` is built on top of TextKit and treats furiganas as custom attributes on the contents `NSAttributedString`.

The custom furigana attributes can coexist with any other text attributes (e.g. `NSFontAttributeName`, `NSForegroundColorAttributeName`, etc.).

We built it this way because we want to support iOS 7, and we want to take advantage of the high level features TextKit API offeres.

## Known Issues

* The `textContainerInset` property of the wrapped `UITextView` seems not working correctly.
* Furiganas displayed in vertical writing is not implemented yet.

