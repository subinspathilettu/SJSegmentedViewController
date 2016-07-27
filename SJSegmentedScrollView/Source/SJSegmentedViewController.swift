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

@objc public protocol SJSegmentedViewControllerViewSource {
    
    /**
     By default, SJSegmentedScrollView will observe the default view of viewcontroller for content
     changes and makes the scroll effect. If you want to change the default view, implement
     SJSegmentedViewControllerViewSource and pass your custom view.
     
     - parameter controller: UIViewController for segment
     - parameter index:      index of segment controller
     
     - returns: observe view
     */
    @objc optional func viewForSegmentControllerToObserveContentOffsetChange(_ controller: UIViewController,
                                                                       index: Int) -> UIView
}

public class SJSegmentedViewController: UIViewController {
    
    /// Set height for headerview. Default height is 200.0.
    public var headerViewHeight: CGFloat = 200.0 {
        didSet {
            segmentedScrollView.headerViewHeight = headerViewHeight
        }
    }
    
    /// Set height for segment view. Default height is 40.0
    public var segmentViewHeight: CGFloat = 40.0 {
        didSet {
            segmentedScrollView.segmentViewHeight = segmentViewHeight
        }
    }
    
    /// Set headerview offset height.
    public var headerViewOffsetHeight: CGFloat = 0.0 {
        didSet {
            self.segmentedScrollView.headerViewOffsetHeight = headerViewOffsetHeight
        }
    }
    
    /// Set color for selected segment. Default color is light gray.
    public var selectedSegmentViewColor = UIColor.lightGray() {
        didSet {
            segmentedScrollView.selectedSegmentViewColor = selectedSegmentViewColor
        }
    }
    
    /// Set height for selected segment view. Default is 5.0.
    public var selectedSegmentViewHeight: CGFloat = 5.0 {
        didSet {
            segmentedScrollView.selectedSegmentViewHeight = selectedSegmentViewHeight
        }
    }
    
    /// Set color for segment title. Default is black.
    public var segmentTitleColor = UIColor.black() {
        didSet {
            segmentedScrollView.segmentTitleColor = segmentTitleColor
        }
    }
    
    /// Set color for segment background. Default is white.
    public var segmentBackgroundColor = UIColor.white() {
        didSet {
            segmentedScrollView.segmentBackgroundColor = segmentBackgroundColor
        }
    }
    
    /// Set font for segment title.
    public var segmentTitleFont = UIFont.systemFont(ofSize: 14.0) {
        didSet {
            segmentedScrollView.segmentTitleFont = segmentTitleFont
        }
    }
    
    /// ViewController for header view.
    public var headerViewController: UIViewController?
    
    /// Array of ViewControllers for segments. 
    public var contentControllers = [UIViewController]()
    
    var segmentedScrollView = SJSegmentedScrollView(frame: CGRect.zero)
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
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
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
        
        self.view.backgroundColor = UIColor.white()
        self.automaticallyAdjustsScrollViewInsets = false
        loadControllers()
    }
    
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
    
    func addSegmentedScrollView() {
        
        let topSpacing = getTopSpacing()
        segmentedScrollView.topSpacing = topSpacing
        
        let bottomSpacing = getBottomSpacing()
        segmentedScrollView.bottomSpacing = bottomSpacing
        
        self.view.addSubview(segmentedScrollView)
        
        let horizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[scrollView]-0-|",
                                                                                   options: [],
                                                                                   metrics: nil,
                                                                                   views: ["scrollView": segmentedScrollView])
        self.view.addConstraints(horizontalConstraints)
        
        let verticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:[scrollView]-bp-|",
                                                                                 options: [],
                                                                                 metrics: ["tp": topSpacing,
                                                                                    "bp": bottomSpacing],
                                                                                 views: ["scrollView": segmentedScrollView])
        self.view.addConstraints(verticalConstraints)
        
        segmentScrollViewTopConstraint = NSLayoutConstraint(item: segmentedScrollView,
                                                            attribute: .top,
                                                            relatedBy: .equal,
                                                            toItem: self.view,
                                                            attribute: .top,
                                                            multiplier: 1.0,
                                                            constant: topSpacing)
        self.view.addConstraint(segmentScrollViewTopConstraint!)
        
        segmentedScrollView.setContentView()
    }
    
    func addHeaderViewController(_ headerViewController: UIViewController) {
        
        self.headerViewController = headerViewController
        self.addChildViewController(headerViewController)
        segmentedScrollView.addHeaderView(headerViewController.view)
        headerViewController.didMove(toParentViewController: self)
    }
    
    func addContentControllers(_ contentControllers: [UIViewController]) {
        
        self.contentControllers = contentControllers
        segmentedScrollView.addSegmentView(contentControllers)
        
        var index = 0
        for controller in contentControllers {
            
            self.addChildViewController(controller)
            segmentedScrollView.addContentView(controller.view)
            controller.didMove(toParentViewController: self)
            
            let delegate = controller as? SJSegmentedViewControllerViewSource
            var observeView = controller.view
            
            if let view = delegate?.viewForSegmentControllerToObserveContentOffsetChange!(controller,
                                                                                         index: index) {
                observeView = view
            }
            
            segmentedScrollView.addObserverFor(view: observeView!)
            index += 1
        }
        
        segmentedScrollView.segmentView?.contentView = segmentedScrollView.contentView
    }
    
    func loadControllers() {
        
        if headerViewController != nil  {
            addHeaderViewController(headerViewController!)
        }
        
        addContentControllers(self.contentControllers)
    }
    
    override public func willAnimateRotation(to toInterfaceOrientation: UIInterfaceOrientation,
                                                                   duration: TimeInterval) {
        let topSpacing = getTopSpacing()
        segmentedScrollView.topSpacing = topSpacing
        segmentedScrollView.bottomSpacing = getBottomSpacing()
        segmentScrollViewTopConstraint?.constant = topSpacing
        segmentedScrollView.updateSubviewsFrame()
        self.view.layoutIfNeeded()
    }
    
    //MARK:- Private Functions
    //MARK:-
    
    func getTopSpacing() -> CGFloat {
        
        var topSpacing = UIApplication.shared().statusBarFrame.size.height
        
        if let navigationController = self.navigationController {
            if !navigationController.isNavigationBarHidden {
                topSpacing += navigationController.navigationBar.bounds.height
            }
        }
        return topSpacing
    }
    
    func getBottomSpacing() -> CGFloat {
        
        var bottomSpacing: CGFloat = 0.0
        
        if let tabBarController = self.tabBarController {
            if !tabBarController.tabBar.isHidden {
                bottomSpacing += tabBarController.tabBar.bounds.size.height
            }
        }
        
        return bottomSpacing
    }
}
