# SJSegmentedScrollView

[![CI Status](https://img.shields.io/travis/subinspathilettu/SJSegmentedViewController.svg?style=flat)](https://travis-ci.org/subinspathilettu/SJSegmentedViewController)
[![Version](https://img.shields.io/cocoapods/v/SJSegmentedScrollView.svg?style=flat)](http://cocoapods.org/pods/SJSegmentedScrollView)
[![License](https://img.shields.io/cocoapods/l/SJSegmentedScrollView.svg?style=flat)](http://cocoapods.org/pods/SJSegmentedScrollView)
[![Platform](https://img.shields.io/cocoapods/p/SJSegmentedScrollView.svg?style=flat)](http://cocoapods.org/pods/SJSegmentedScrollView)

SJSegmentedScrollView is a light weight generic controller written in Swift. Its a simple customizable controller were you can integrate any number of ViewControllers into a segmented controller with a header view controller.

![sample_gif](http://g.recordit.co/TKqjr0g6gj.gif)

#### Highlights

- [x] Horizontal scrolling for switching from segment to segment.
- [x] Vertical scrolling for contents.
- [x] Single header view for all segments.
- [x] Title, segment selection color, header size, segment height etc can be customized accordingly.
- [x] Supports Swift and Objective-C.
- [x] Supports multitasking.
- [x] Supports Refreshcontrol and custom pull to refresh libs.

## Installation

### CocoaPods:

[CocoaPods](http://cocoapods.org) is a dependency manager for Cocoa projects. You can install it with the following command:

```bash
$ gem install cocoapods
```

To integrate `SJSegmentedViewController` into your Xcode project using CocoaPods, specify it in your Podfile:
```ruby

source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '9.0'
use_frameworks!

target '<Your Target Name>' do
pod ’SJSegmentedScrollView’, ‘1.3.5'
end
```

Then, run the following command:

```bash
$ pod install
```

### Manually:

* Download SJSegmentedViewController.
* Drag and drop SJSegmentedViewController directory to your project

## Requirements

- Xcode 7.3+
- iOS 9.0+
- Swift 2.3+

## Communication

- If you **found a bug**, open an issue.
- If you **have a feature request**, open an issue.
- If you **want to contribute**, submit a pull request.

## Donation

If this project help you reduce time to develop, you can give me a beer 🍺 :)

[![paypal](https://www.paypalobjects.com/en_US/i/btn/btn_donateCC_LG.gif)](https://www.paypal.me/SubinsJose)

## Usage

Here is how you can use `SJSegmentedViewController`. 

Import SJSegmentedScrollView to your viewcontroller,

```swift
import SJSegmentedScrollView
```

Then add any number of ViewControllers into `SJSegmentedViewController`. All you have to do is as follows.

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
```

* Present ViewController
```swift
self.presentViewController(segmentedViewController, animated: false, completion: nil)
```

* Push ViewController
```swift
self.navigationController?.pushViewController(segmentedViewController,
                                                          animated: true)
```

* Add Child ViewController
```swift
addChildViewController(segmentedViewController)
self.view.addSubview(segmentedViewController.view)
segmentedViewController.view.frame = self.view.bounds
segmentedViewController.didMoveToParentViewController(self)
```
#### For `Swift 2.3`
We upgraded to `Swift 3`. For those who want to use older version, use `1.1.1` .

```ruby
pod 'SJSegmentedScrollView', :git => 'https://github.com/subinspathilettu/SJSegmentedViewController.git', :tag => 'v1.1.1'
```
#### Customize Segement Tab
Defaultly, SJSegmentedScrollView shows the `controller.title` as segments tab. 

```swift
firstViewController.title = "First"
```

You can customize the segment tab view by providing `controller.navigationItem.titleView`.

```swift
// Custom ImageView
let view = UIImageView()
view.frame.size.width = 100
view.image = UIImage(named: imageName)
view.contentMode = .scaleAspectFit
view.backgroundColor = .white

firstViewController.navigationItem.titleView = view
```

#### Customize your view
By default, SJSegmentedScrollView will observe the default view of viewcontroller for content 
changes and makes the scroll effect. If you want to change the default view, implement 
`SJSegmentedViewControllerViewSource` and pass your custom view. 

```swift
func viewForSegmentControllerToObserveContentOffsetChange(controller: UIViewController,
    index: Int) -> UIView {
    return view
}
```

`SJSegmentedViewControllerDelegate` delegate method which helps to customize segment view by accessing the current segment, index,
etc. 

Note: if there is only one content controller then the segment will be empty. 

```swift

segmentedViewController.delegate = self

extension ViewController: SJSegmentedViewControllerDelegate {
    
    func didMoveToPage(controller: UIViewController, segment: SJSegmentTab?, index: Int) {
        if segmentedViewController.segments.count > 0 {
            
            let segmentTab = segmentedViewController.segments[index]
            segmentTab.titleColor = .yellow
        }
    }
}
```

You can also customize your controllers by using following properties in `SJSegmentedViewController`.

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

//Set shadow for segmentview.
segmentedViewController.segmentShadow = SJShadow.light()

//Set bounce for segmentview.
segmentedViewController.segmentBounces = true

//Set font for segmentview titles.
segmentedViewController.segmentTitleFont = UIFont.systemFontOfSize(14.0)

//Set height for selected segmentview.
segmentedViewController.selectedSegmentViewHeight = 5.0

//Set height for headerview to visible after scrolling
segmentedViewController. headerViewOffsetHeight = 10.0
```

#### Change Segment Programmatically


To change segment programmatically, use `SJSegmentedViewController` `func setSelectedSegmentAt(_ index: Int, animated: Bool)`.

```swift
segmentControl.setSelectedSegmentAt(index, animated: true)
```

## Author

Subins Jose, subinsjose@gmail.com

## License

SJSegmentedScrollView is available under the MIT license. See the LICENSE file for more info.
