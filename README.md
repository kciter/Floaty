# Floaty
![Swift 3.0](https://img.shields.io/badge/Swift-3.0-orange.svg)
[![Version](https://img.shields.io/cocoapods/v/Floaty.svg?style=flat)](http://cocoapods.org/pods/floaty)
[![License](https://img.shields.io/cocoapods/l/Floaty.svg?style=flat)](http://cocoapods.org/pods/floaty)
[![Platform](https://img.shields.io/cocoapods/p/Floaty.svg?style=flat)](http://cocoapods.org/pods/floaty)
[![Build Status](https://travis-ci.org/kciter/Floaty.svg?branch=master)](https://travis-ci.org/kciter/floaty)

Floaty is simple floating action button for iOS. (formerly KCFloatingActionButton)
> Why change the name?
> 1. Follow the swift naming convention.
> 2. `KCFloatingActionButton` is too long.

## Preview
<img src="https://github.com/kciter/Floaty/raw/master/Images/preview.gif" width='187' alt="Preview gif">

## Requirements
* iOS 9.0+
* Swift 3.0+
* Xcode 8

## Installation
### CocoaPods
```ruby
use_frameworks!
pod "Floaty", "~> 3.0.0" # Use version 4.0.0 for Swift 4.0
```
### Carthage
```ruby
github "kciter/Floaty"
```
### Manually
To install manually the Floaty in an app, just drag the `Floaty/*.swift` file into your project.

## Usage
### Storyboard support
<img src="https://github.com/kciter/Floaty/raw/master/Images/storyboard_support1.png" height='300' alt="Storyboard support1">
<img src="https://github.com/kciter/Floaty/raw/master/Images/storyboard_support2.png" height='300' alt="Storyboard support2">

### Dependent on the UIWindow.
```swift
Floaty.global.button.addItem(title: "Hello, World!")
Floaty.global.show()
```
<img src="https://github.com/kciter/Floaty/raw/master/Images/dependent_on_uiwindow.gif" width='187' alt="Dependent on the UIWindow">

### Dependent on the UIViewController.
```swift
let floaty = Floaty()
floaty.addItem(title: "Hello, World!")
self.view.addSubview(floaty)
```
<img src="https://github.com/kciter/Floaty/raw/master/Images/dependent_on_uiviewcontroller.gif" width='187' alt="Dependent on the UIViewController">

### Use icon
```swift
let floaty = Floaty()
floaty.addItem("Hello, World!", icon: UIImage(named: "icon")!)
self.view.addSubview(floaty)
```
<img src="https://github.com/kciter/Floaty/raw/master/Images/icon.png" width='187' alt="Use icon">

### Use handler
#### Swift
```swift
let floaty = Floaty()
floaty.addItem("I got a handler", icon: UIImage(named: "icon")!, handler: { item in
    let alert = UIAlertController(title: "Hey", message: "I'm hungry...", preferredStyle: .Alert)
    alert.addAction(UIAlertAction(title: "Me too", style: .Default, handler: nil))
    self.presentViewController(alert, animated: true, completion: nil)
    fab.close()
})
self.view.addSubview(floaty)
```
<img src="https://github.com/kciter/Floaty/raw/master/Images/handler.gif" width='187' alt="Use handler">

### Use custom item
```swift
let item = FloatyItem()
item.buttonColor = UIColor.blueColor()
item.title = "Custom item"
Floaty.global.button.addItem(item: item)
```
<img src="https://github.com/kciter/Floaty/raw/master/Images/custom_item.png" width='187' alt="Use custom item">


### RTL Support
You can use the `rtlMode` property to mirror the Floaty Button for rtl languages.
```swift
Floaty.global.rtlMode = true
```
<img src="https://github.com/divgunsingh/Floaty/raw/master/Images/rtl_enabled.png" width='187' alt="Rtl Enabled">
<img src="https://github.com/divgunsingh/Floaty/raw/master/Images/rtl_disabled.png" width='187' alt="Rtl Disabled">



### Sticky
You can use the `sticky` property.
```swift
floaty.sticky = true // sticking to parent UIScrollView(also UITableView, UICollectionView)
scrollView.addSubview(floaty)
```

### Friendly Tap
You can use the `friendlyTap` property.
```swifty
fab.friendlyTap = true
scrollView.addSubview(fab)
```
With the default location of the frame, the button is now tappable until the right and rightbottom of the screen. This prevents tapping behind it by accident.

### Animation type
<table>
<tr>
<th>Pop</th><th>Fade</th><th>Slide Left</th>
</tr>
<tr>
<td><img src="https://github.com/kciter/Floaty/raw/master/Images/preview.gif" width='187' alt="Pop animation gif"></td>
<td><img src="https://github.com/kciter/Floaty/raw/master/Images/fade_ani.gif" width='187' alt="Fade animation gif"></td>
<td><img src="https://github.com/kciter/Floaty/raw/master/Images/slideleft_ani.gif" width='187' alt="Slide left animation gif"></td>
</tr>
<tr>
<th>Slide Up</th><th>None</th>
</tr>
<tr>
<td><img src="https://github.com/kciter/Floaty/raw/master/Images/slideup_ani.gif" width='187' alt="Slide up animation gif"></td>
<td><img src="https://github.com/kciter/Floaty/raw/master/Images/none_ani.gif" width='187' alt="None animation gif"></td>
</tr>
</table>

## ToDo
* [ ] Labels to come at the right hand side of the FAB Item menu.

## Donate
If you like this open source, you can sponsor it. :smile:

[Paypal me](https://paypal.me/kciter)

## License
The MIT License (MIT)

Copyright (c) 2015 Lee Sun-Hyoup

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
