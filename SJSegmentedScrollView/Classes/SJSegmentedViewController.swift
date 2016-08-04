//
//  SJSegmentedViewController.swift
//  Pods
//
//  Created by Subins Jose on 20/06/16.
//  Copyright © 2016 Subins Jose. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and
//    associated documentation files (the "Software"), to deal in the Software without restriction,
//    including without limitation the rights to use, copy, modify, merge, publish, distribute,
//    sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is
//    furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all copies or
//    substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT
//  LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
//  IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
//  SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

import UIKit

/**
 *  Public protocol of  SJSegmentedViewController for content changes and makes the scroll effect.
 */
@objc public protocol SJSegmentedViewControllerViewSource {
    
    /**
     By default, SJSegmentedScrollView will observe the default view of viewcontroller for content
     changes and makes the scroll effect. If you want to change the default view, implement
     SJSegmentedViewControllerViewSource and pass your custom view.
     
     - parameter controller: UIViewController for segment
     - parameter index:      index of segment controller
     
     - returns: observe view
     */
    optional func viewForSegmentControllerToObserveContentOffsetChange(controller: UIViewController,
                                                                       index: Int) -> UIView
}

/**
 *  Public class for customizing and setting our segmented scroll view
 */
@objc public class SJSegmentedViewController: UIViewController {
    
    /**
     *  The headerview height for 'Header'.
     *
     *  By default the height will be 200.0
     *
     *  segmentedViewController.headerViewHeight = 250.0
     */
    public var headerViewHeight: CGFloat = 200.0 {
        didSet {
            segmentedScrollView.headerViewHeight = headerViewHeight
        }
    }
    
    /**
     *  Set height for segment view.
     *
     *  By default the height is 40.0
     *
     *  segmentedViewController.segmentViewHeight = 60.0
     */
    public var segmentViewHeight: CGFloat = 40.0 {
        didSet {
            segmentedScrollView.segmentViewHeight = segmentViewHeight
        }
    }
    
    /**
     *  Set headerview offset height.
     *
     *  By default the height is 0.0
     *
     *  segmentedViewController. headerViewOffsetHeight = 10.0
     */
    public var headerViewOffsetHeight: CGFloat = 0.0 {
        didSet {
            self.segmentedScrollView.headerViewOffsetHeight = headerViewOffsetHeight
        }
    }
    
    /**
     *  Set color for selected segment.
     *
     *  By default the color is light gray.
     *
     *  segmentedViewController.selectedSegmentViewColor = UIColor.redColor()
     */
    public var selectedSegmentViewColor = UIColor.lightGrayColor() {
        didSet {
            segmentedScrollView.selectedSegmentViewColor = selectedSegmentViewColor
        }
    }
    
    /**
     *  Set height for selected segment view.
     *
     *  By default the height is 5.0
     *
     *  segmentedViewController.selectedSegmentViewHeight = 5.0
     */
    public var selectedSegmentViewHeight: CGFloat = 5.0 {
        didSet {
            segmentedScrollView.selectedSegmentViewHeight = selectedSegmentViewHeight
        }
    }
    
    /**
     *  Set color for segment title.
     *
     *  By default the color is black.
     *
     *  segmentedViewController.segmentTitleColor = UIColor.redColor()
     */
    public var segmentTitleColor = UIColor.blackColor() {
        didSet {
            segmentedScrollView.segmentTitleColor = segmentTitleColor
        }
    }
    
    /**
     *  Set color for segment background.
     *
     *  By default the color is white.
     *
     *  segmentedViewController.segmentBackgroundColor = UIColor.whiteColor()
     */
    public var segmentBackgroundColor = UIColor.whiteColor() {
        didSet {
            segmentedScrollView.segmentBackgroundColor = segmentBackgroundColor
        }
    }
    
    /**
     *  Set font for segment title.
     *
     *  segmentedViewController.segmentTitleFont = UIFont.systemFontOfSize(14.0)
     */
    public var segmentTitleFont = UIFont.systemFontOfSize(14.0) {
        didSet {
            segmentedScrollView.segmentTitleFont = segmentTitleFont
        }
    }
    
    /**
     *  Set ViewController for header view.
     */
    public var headerViewController: UIViewController? {
        didSet {
            setDefaultValuesToSegmentedScrollView()
        }
    }
    
    /**
     *  Array of ViewControllers for segments.
     */
    public var contentControllers = [UIViewController]() {
        didSet {
            setDefaultValuesToSegmentedScrollView()
        }
    }
    
    var segmentedScrollView = SJSegmentedScrollView(frame: CGRectZero)
    var segmentScrollViewTopConstraint: NSLayoutConstraint?
    
    /**
     Custom initializer for SJSegmentedViewController.
     
     - parameter headerViewController: A UIViewController
     - parameter segmentControllers:   Array of UIViewControllers for segments.

     */
    convenience public init(headerViewController: UIViewController,
                            segmentControllers: [UIViewController]) {
        self.init(nibName: nil, bundle: nil)
        
        self.headerViewController = headerViewController
        self.contentControllers = segmentControllers
        
        setDefaultValuesToSegmentedScrollView()
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func loadView() {
        super.loadView()
        addSegmentedScrollView()
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.whiteColor()
        self.automaticallyAdjustsScrollViewInsets = false
        loadControllers()
    }
    
    /**
     * Set the default values for the segmented scroll view.
     */
    func setDefaultValuesToSegmentedScrollView() {
        
        segmentedScrollView.selectedSegmentViewColor    = self.selectedSegmentViewColor
        segmentedScrollView.selectedSegmentViewHeight   = self.selectedSegmentViewHeight
        segmentedScrollView.segmentTitleColor           = self.segmentTitleColor
        segmentedScrollView.segmentBackgroundColor      = self.segmentBackgroundColor
        segmentedScrollView.segmentTitleFont            = self.segmentTitleFont
        segmentedScrollView.headerViewHeight            = self.headerViewHeight
        segmentedScrollView.headerViewOffsetHeight      = self.headerViewOffsetHeight
        segmentedScrollView.segmentViewHeight           = self.segmentViewHeight
    }
    
    /**
     * Private method for adding the segmented scroll view.
     */
    func addSegmentedScrollView() {
        
        let topSpacing = getTopSpacing()
        segmentedScrollView.topSpacing = topSpacing
        
        let bottomSpacing = getBottomSpacing()
        segmentedScrollView.bottomSpacing = bottomSpacing
        
        self.view.addSubview(segmentedScrollView)
        
        let horizontalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[scrollView]-0-|",
                                                                                   options: [],
                                                                                   metrics: nil,
                                                                                   views: ["scrollView": segmentedScrollView])
        self.view.addConstraints(horizontalConstraints)
        
        let verticalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:[scrollView]-bp-|",
                                                                                 options: [],
                                                                                 metrics: ["tp": topSpacing,
                                                                                    "bp": bottomSpacing],
                                                                                 views: ["scrollView": segmentedScrollView])
        self.view.addConstraints(verticalConstraints)
        
        segmentScrollViewTopConstraint = NSLayoutConstraint(item: segmentedScrollView,
                                                            attribute: .Top,
                                                            relatedBy: .Equal,
                                                            toItem: self.view,
                                                            attribute: .Top,
                                                            multiplier: 1.0,
                                                            constant: topSpacing)
        self.view.addConstraint(segmentScrollViewTopConstraint!)
        
        segmentedScrollView.setContentView()
    }
    
    /**
     Method for adding the HeaderViewController into the container
     
     - parameter headerViewController: Header ViewController.
     */
    func addHeaderViewController(headerViewController: UIViewController) {
        
        self.addChildViewController(headerViewController)
        segmentedScrollView.addHeaderView(headerViewController.view)
        headerViewController.didMoveToParentViewController(self)
    }
    
    /**
     Method for adding the array of content ViewControllers into the container
     
     - parameter contentControllers: array of ViewControllers
     */
    func addContentControllers(contentControllers: [UIViewController]) {
        
        segmentedScrollView.addSegmentView(contentControllers)
        
        var index = 0
        for controller in contentControllers {
            
            self.addChildViewController(controller)
            segmentedScrollView.addContentView(controller.view)
            controller.didMoveToParentViewController(self)
            
            let delegate = controller as? SJSegmentedViewControllerViewSource
            var observeView = controller.view
            
            if let view = delegate?.viewForSegmentControllerToObserveContentOffsetChange!(controller,
                                                                                         index: index) {
                observeView = view
            }
            
            segmentedScrollView.addObserverFor(view: observeView)
            index += 1
        }
        
        segmentedScrollView.segmentView?.contentView = segmentedScrollView.contentView
    }
    
    /**
     * Method for loading content ViewControllers and header ViewController
     */
    func loadControllers() {
        
        if headerViewController != nil  {
            addHeaderViewController(headerViewController!)
        }
        
        addContentControllers(self.contentControllers)
    }
    
    /**
     * Method for handling rotation of viewcontroller
     */
    override public func willAnimateRotationToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation,
                                                                   duration: NSTimeInterval) {
        let topSpacing = getTopSpacing()
        segmentedScrollView.topSpacing = topSpacing
        segmentedScrollView.bottomSpacing = getBottomSpacing()
        segmentScrollViewTopConstraint?.constant = topSpacing
        segmentedScrollView.updateSubviewsFrame()
        self.view.layoutIfNeeded()
    }
    
    /**
     * Method to get topspacing of container,
     
     - returns: topspace in float
     */
    func getTopSpacing() -> CGFloat {
        
        var topSpacing = UIApplication.sharedApplication().statusBarFrame.size.height
        
        if let navigationController = self.navigationController {
            if !navigationController.navigationBarHidden {
                topSpacing += navigationController.navigationBar.bounds.height
            }
        }
        return topSpacing
    }
    
    /**
     * Method to get bottomspacing of container
     
     - returns: bottomspace in float
     */
    func getBottomSpacing() -> CGFloat {
        
        var bottomSpacing: CGFloat = 0.0
        
        if let tabBarController = self.tabBarController {
            if !tabBarController.tabBar.hidden {
                bottomSpacing += tabBarController.tabBar.bounds.size.height
            }
        }
        
        return bottomSpacing
    }
}