# KCFloatingActionButton
![Swift 3.0](https://img.shields.io/badge/Swift-3.0-orange.svg)
[![Version](https://img.shields.io/cocoapods/v/KCFloatingActionButton.svg?style=flat)](http://cocoapods.org/pods/kcfloatingactionbutton)
[![License](https://img.shields.io/cocoapods/l/KCFloatingActionButton.svg?style=flat)](http://cocoapods.org/pods/kcfloatingactionbutton)
[![Platform](https://img.shields.io/cocoapods/p/KCFloatingActionButton.svg?style=flat)](http://cocoapods.org/pods/kcfloatingactionbutton)
[![Build Status](https://travis-ci.org/kciter/KCFloatingActionButton.svg?branch=master)](https://travis-ci.org/kciter/KCFloatingActionButton)

Simple Floating Action Button for iOS

## Preview
<img src="https://github.com/kciter/KCFloatingActionButton/raw/master/Images/preview.gif" width='187' alt="Preview gif">

## Requirements
* iOS 9.0+
* Swift 3.0
* Xcode 8

## Installation
### CocoaPods
```ruby
use_frameworks!
pod "KCFloatingActionButton", "~> 2.1.0"
```
### Carthage
```ruby
github "kciter/KCFloatingActionButton"
```
### Manually
To install manually the KCFloatingActionButton in an app, just drag the `KCFloatingActionButton/*.swift` file into your project.

## Usage
### Storyboard support
<img src="https://github.com/kciter/KCFloatingActionButton/raw/master/Images/storyboard_support1.png" height='300' alt="Storyboard support1">
<img src="https://github.com/kciter/KCFloatingActionButton/raw/master/Images/storyboard_support2.png" height='300' alt="Storyboard support2">

### Dependent on the UIWindow.
#### Swift
```swift
KCFABManager.defaultInstance().getButton().addItem(title: "Hello, World!")
KCFABManager.defaultInstance().show()
```
#### Objective-C
````objc
[[[KCFABManager defaultInstance] getButton] addItemWithTitle:@"Hello, world!"];
[[KCFABManager defaultInstance] show:true];
````
<img src="https://github.com/kciter/KCFloatingActionButton/raw/master/Images/dependent_on_uiwindow.gif" width='187' alt="Dependent on the UIWindow">

### Dependent on the UIViewController.
#### Swift
```swift
let fab = KCFloatingActionButton()
fab.addItem(title: "Hello, World!")
self.view.addSubview(fab)
```
#### Objective-C
```objc
KCFloatingActionButton *fab = [[KCFloatingActionButton alloc] init];
[fab addItemWithTitle:@"Hello, World!"];
[self.view addSubview:fab];
```
<img src="https://github.com/kciter/KCFloatingActionButton/raw/master/Images/dependent_on_uiviewcontroller.gif" width='187' alt="Dependent on the UIViewController">

### Use icon
#### Swift
```swift
let fab = KCFloatingActionButton()
fab.addItem("Hello, World!", icon: UIImage(named: "icon")!)
self.view.addSubview(fab)
```
#### Objective-C
```objc
KCFloatingActionButton *fab = [[KCFloatingActionButton alloc] init];
[fab addItem:@"Hello, World" icon:[UIImage imageNamed:@"icon"]];
[self.view addSubview:fab];
```
<img src="https://github.com/kciter/KCFloatingActionButton/raw/master/Images/icon.png" width='187' alt="Use icon">

### Use handler
#### Swift
```swift
let fab = KCFloatingActionButton()
fab.addItem("I got a handler", icon: UIImage(named: "icon")!, handler: { item in
    let alert = UIAlertController(title: "Hey", message: "I'm hungry...", preferredStyle: .Alert)
    alert.addAction(UIAlertAction(title: "Me too", style: .Default, handler: nil))
    self.presentViewController(alert, animated: true, completion: nil)
    fab.close()
})
self.view.addSubview(fab)
```
#### Objective-C
```objc
KCFloatingActionButton *fab = [[KCFloatingActionButton alloc] init];
__weak KCFloatingActionButton *_fab = fab;
[fab addItem:@"I got a handler" icon:[UIImage imageNamed:@"icon"] handler:^(KCFloatingActionButtonItem *item) {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Hey" message:@"I'm hungry..." preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"Me too" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alert animated:true completion:nil];
    [_fab close];
}];
[self.view addSubview:fab];
```
<img src="https://github.com/kciter/KCFloatingActionButton/raw/master/Images/handler.gif" width='187' alt="Use handler">

### Use custom item
#### Swift
```swift
let item = KCFloatingActionButtonItem()
item.buttonColor = UIColor.blueColor()
item.title = "Custom item"
KCFABManager.defaultInstance().getButton().addItem(item: item)
```
#### Objective-C
```objc
KCFloatingActionButtonItem *item = [[KCFloatingActionButtonItem alloc] init];
item.buttonColor = [UIColor blueColor];
item.title = @"Custom item";
[[[KCFABManager defaultInstance] getButton] addItemWithItem:item];
```
<img src="https://github.com/kciter/KCFloatingActionButton/raw/master/Images/custom_item.png" width='187' alt="Use custom item">

### Sticky
You can use the `sticky` property.
```swift
fab.sticky = true // sticking to parent UIScrollView(also UITableView, UICollectionView)
scrollView.addSubview(fab)
```

### Animation type
<table>
<tr>
<th>Pop</th><th>Fade</th><th>Slide Left</th>
</tr>
<tr>
<td><img src="https://github.com/kciter/KCFloatingActionButton/raw/master/Images/preview.gif" width='187' alt="Pop animation gif"></td>
<td><img src="https://github.com/kciter/KCFloatingActionButton/raw/master/Images/fade_ani.gif" width='187' alt="Fade animation gif"></td>
<td><img src="https://github.com/kciter/KCFloatingActionButton/raw/master/Images/slideleft_ani.gif" width='187' alt="Slide left animation gif"></td>
</tr>
<tr>
<th>Slide Up</th><th>None</th>
</tr>
<tr>
<td><img src="https://github.com/kciter/KCFloatingActionButton/raw/master/Images/slideup_ani.gif" width='187' alt="Slide up animation gif"></td>
<td><img src="https://github.com/kciter/KCFloatingActionButton/raw/master/Images/none_ani.gif" width='187' alt="None animation gif"></td>
</tr>
</table>

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
