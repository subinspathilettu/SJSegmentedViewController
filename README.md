# SJSegmentedScrollView

[![CI Status](https://img.shields.io/travis/subinspathilettu/SJSegmentedViewController.svg?style=flat)](https://travis-ci.org/subinspathilettu/SJSegmentedViewController)
[![Version](https://img.shields.io/cocoapods/v/SJSegmentedScrollView.svg?style=flat)](http://cocoapods.org/pods/SJSegmentedScrollView)
[![License](https://img.shields.io/cocoapods/l/SJSegmentedScrollView.svg?style=flat)](http://cocoapods.org/pods/SJSegmentedScrollView)
[![Platform](https://img.shields.io/cocoapods/p/SJSegmentedScrollView.svg?style=flat)](http://cocoapods.org/pods/SJSegmentedScrollView)

SJSegmentedScrollView is a light weight generic controller written in Swift 2.3. Its a simple customizable controller were you can integrate any number of ViewControllers into a segmented controller with a header view controller.

![sample_gif](http://g.recordit.co/TKqjr0g6gj.gif)

#### Highlights

* Horizontal scrolling for switching from segment to segment.
* Vertical scrolling for contents.
* Single header view for all segments.
* Title, segment selection color, header size, segment height etc can be customized accordingly.

## Installation

### Using CocoaPods:

To integrate SJSegmentedViewController into your Xcode project using CocoaPods, specify it in your Podfile:
```swift

source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '9.0'
use_frameworks!

target '<Your Target Name>' do
pod ’SJSegmentedScrollView’, ‘1.0.11'
end
```
Then, run the following command:
```swift
$ pod install
```

### Manually:

* Download SJSegmentedViewController.
* Drag and drop SJSegmentedViewController directory to your project

## Requirements

iOS 8.0+, Swift 2.3

## Usage

Here is how you can use SJSegmentedViewController. 

You can add any number of ViewControllers into SJSegmentedViewController. All you have to do is as follows.
```swift
if let storyboard = self.storyboard {

let headerViewController = storyboard
    .instantiateViewControllerWithIdentifier("HeaderViewController")

let firstViewController = storyboard
    .instantiateViewControllerWithIdentifier("FirstTableViewController")
firstViewController.title = "First"

let secondViewController = storyboard
    .instantiateViewControllerWithIdentifier("SecondTableViewController")
secondViewController.title = "Second"

let thirdViewController = storyboard
    .instantiateViewControllerWithIdentifier("ThirdTableViewController")
thirdViewController.title = "Third"

let segmentedViewController = SJSegmentedViewController(headerViewController: headerViewController,
segmentControllers: [firstViewController,
	secondViewController,
	thirdViewController])
self.presentViewController(segmentedViewController, animated: false, completion: nil)
}
```
#### Customize your view
By default, SJSegmentedScrollView will observe the default view of viewcontroller for content 
changes and makes the scroll effect. If you want to change the default view, implement 
SJSegmentedViewControllerViewSource and pass your custom view. 

```swift
func viewForSegmentControllerToObserveContentOffsetChange(controller: UIViewController,
    index: Int) -> UIView {
    return view
}
```

You can also customize your controllers by using following properties in SJSegmentedViewController.

```swift
let segmentedViewController = SJSegmentedViewController()

//Set height for headerview.
segmentedViewController.headerViewHeight = 250.0

//Set height for segmentview.
segmentedViewController.segmentViewHeight = 60.0

//Set color for selected segment.
segmentedViewController.selectedSegmentViewColor = UIColor.redColor()

//Set color for segment title.
segmentedViewController.segmentTitleColor = UIColor.blackColor()

//Set background color for segmentview.
segmentedViewController.segmentBackgroundColor = UIColor.whiteColor()

//Set font for segmentview titles.
segmentedViewController.segmentTitleFont = UIFont.systemFontOfSize(14.0)

//Set height for selected segmentview.
segmentedViewController.selectedSegmentViewHeight = 5.0

//Set height for headerview to visible after scrolling
segmentedViewController. headerViewOffsetHeight = 10.0
```




## Author

Subins Jose, subinsjose@gmail.com

## License

SJSegmentedScrollView is available under the MIT license. See the LICENSE file for more info.
