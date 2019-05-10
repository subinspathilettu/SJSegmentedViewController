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

@objc public protocol SJSegmentedViewControllerDelegate {
    
    @objc optional func didSelectSegmentAtIndex(_ index:Int)
    
    /**
     Method to identify the current controller and segment of contentview
     
     - parameter controller: Current controller
     - parameter segment: selected segment
     - parameter index: index of selected segment.
     */
    @objc optional func didMoveToPage(_ controller: UIViewController, segment: SJSegmentTab?, index: Int)
}

/**
 *  Public protocol of  SJSegmentedViewController for content changes and makes the scroll effect.
 */
@objc public protocol SJSegmentedViewControllerViewSource {
    
    /**
     By default, SJSegmentedScrollView will observe the default view of viewcontroller for content
     changes and makes the scroll effect. If you want to change the default view, implement
     SJSegmentedViewControllerViewSource and pass your custom view.
     
     - returns: observe view
     */
    @objc optional func viewForSegmentControllerToObserveContentOffsetChange() -> UIView
}

/**
 *  Public class for customizing and setting our segmented scroll view
 */
@objc open class SJSegmentedViewController: UIViewController {
    
    /**
     *  The headerview height for 'Header'.
     *
     *  By default the height will be 0.0
     *
     *  segmentedViewController.headerViewHeight = 200.0
     */
    open var headerViewHeight: CGFloat = 0.0 {
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
    open var segmentViewHeight: CGFloat = 40.0 {
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
    open var headerViewOffsetHeight: CGFloat = 0.0 {
        didSet {
            segmentedScrollView.headerViewOffsetHeight = headerViewOffsetHeight
        }
    }
    
    /**
     *  Set color for selected segment.
     *
     *  By default the color is light gray.
     *
     *  segmentedViewController.selectedSegmentViewColor = UIColor.redColor()
     */
    open var selectedSegmentViewColor = UIColor.lightGray {
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
    open var selectedSegmentViewHeight: CGFloat = 5.0 {
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
    open var segmentTitleColor = UIColor.black {
        didSet {
            segmentedScrollView.segmentTitleColor = segmentTitleColor
        }
    }
    
    /**
     *  Set color for segment title.
     *
     *  By default the color is black.
     *
     *  segmentedViewController.segmentTitleColor = UIColor.redColor()
     */
    open var segmentSelectedTitleColor = UIColor.black {
        didSet {
            segmentedScrollView.segmentSelectedTitleColor = segmentSelectedTitleColor
        }
    }
    
    /**
     *  Set color for segment background.
     *
     *  By default the color is white.
     *
     *  segmentedViewController.segmentBackgroundColor = UIColor.whiteColor()
     */
    open var segmentBackgroundColor = UIColor.white {
        didSet {
            segmentedScrollView.segmentBackgroundColor = segmentBackgroundColor
        }
    }
    
    /**
     *  Set shadow for segment.
     *
     *  By default the color is light gray.
     *
     *  segmentedViewController.segmentShadow = SJShadow.light()
     */
    open var segmentShadow = SJShadow() {
        didSet {
            segmentedScrollView.segmentShadow = segmentShadow
        }
    }
    
    /**
     *  Set font for segment title.
     *
     *  segmentedViewController.segmentTitleFont = UIFont.systemFontOfSize(14.0)
     */
    open var segmentTitleFont = UIFont.systemFont(ofSize: 14.0) {
        didSet {
            segmentedScrollView.segmentTitleFont = segmentTitleFont
        }
    }
    
    /**
     *  Set bounce for segment.
     *
     *  By default it is set to true.
     *
     *  segmentedViewController.segmentBounces = false
     */
    open var segmentBounces = true {
        didSet {
            segmentedScrollView.segmentBounces = segmentBounces
        }
    }
    
    /**
     *  Set ViewController for header view.
     */
    open var headerViewController: UIViewController? {
        didSet {
            setDefaultValuesToSegmentedScrollView()
        }
    }
    
    /**
     *  Array of ViewControllers for segments.
     */
    open var segmentControllers = [UIViewController]() {
        didSet {
            setDefaultValuesToSegmentedScrollView()
        }
    }
    
    /**
     *  Array of segments. For single view controller segments will be empty.
     */
    open var segments: [SJSegmentTab] {
        get {
            
            if let segmentView = segmentedScrollView.segmentView {
                return segmentView.segments
            }
            
            return [SJSegmentTab]()
        }
    }
    
    /**
     *  Set color of SegmentedScrollView.
     *
     *  By default it is set to white.
     *
     *  segmentedScrollView.backgroundColor  = UIColor.white
     */
    open var segmentedScrollViewColor = UIColor.white  {
        didSet {
            segmentedScrollView.backgroundColor = segmentedScrollViewColor
        }
    }

	/**
	*  Set vertical scroll indicator.
	*
	*  By default true.
	*
	*  segmentedScrollView.showsVerticalScrollIndicator = false
	*/
	open var showsVerticalScrollIndicator = true {
		didSet {
			segmentedScrollView.sjShowsVerticalScrollIndicator = showsVerticalScrollIndicator
		}
	}

	/**
	*  Set horizontal scroll indicator.
	*
	*  By default true.
	*
	*  segmentedScrollView.showsHorizontalScrollIndicator = false
	*/
	open var showsHorizontalScrollIndicator = true {
		didSet {
			segmentedScrollView.sjShowsHorizontalScrollIndicator = showsHorizontalScrollIndicator
		}
	}
    
    /**
     *  Disable scroll on contentView.
     *
     *  By default false.
     *
     *  segmentedScrollView.disableScrollOnContentView = true
     */
    open var disableScrollOnContentView: Bool = false {
        didSet {
            segmentedScrollView.sjDisableScrollOnContentView = disableScrollOnContentView
        }
    }
    
    open weak var delegate:SJSegmentedViewControllerDelegate?
    var segmentedScrollView = SJSegmentedScrollView(frame: CGRect.zero)
    var segmentScrollViewTopConstraint: NSLayoutConstraint?
    
    
    /**
     Custom initializer for SJSegmentedViewController.
     
     - parameter headerViewController: A UIViewController
     - parameter segmentControllers:   Array of UIViewControllers for segments.
     
     */
    required public init(headerViewController: UIViewController?,
                            segmentControllers: [UIViewController]) {
        super.init(nibName: nil, bundle: nil)
        self.headerViewController = headerViewController
        self.segmentControllers = segmentControllers
        setDefaultValuesToSegmentedScrollView()
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required public init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
    }
    
    override open func loadView() {
        super.loadView()
        addSegmentedScrollView()
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        loadControllers()
		if #available(iOS 11, *) {
			segmentedScrollView.contentInsetAdjustmentBehavior = .never
		} else {
			automaticallyAdjustsScrollViewInsets = false
		}
    }
    
    /**
     * Update view as per the current layout
     */
    override open func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let topSpacing = SJUtil.getTopSpacing(self)
        segmentedScrollView.topSpacing = topSpacing
        segmentedScrollView.bottomSpacing = SJUtil.getBottomSpacing(self)
        segmentScrollViewTopConstraint?.constant = topSpacing
        segmentedScrollView.updateSubviewsFrame(view.bounds)
    }

	/**
	* To select segment programmatically
	* - parameter index Int Segment index
	* - parameter animated Bool Move with an animation or not.
	*/
	open func setSelectedSegmentAt(_ index: Int, animated: Bool) {

		if index >= 0 && index < segmentControllers.count {
			segmentedScrollView.segmentView?.didSelectSegmentAtIndex!(segments[index],
			                                                          index,
			                                                          animated)
			NotificationCenter.default.post(name: Notification.Name(rawValue: "DidChangeSegmentIndex"),
			                                object: index)
		}
	}
    
    /**
     * Set the default values for the segmented scroll view.
     */
    func setDefaultValuesToSegmentedScrollView() {
        
        segmentedScrollView.selectedSegmentViewColor    = selectedSegmentViewColor
        segmentedScrollView.selectedSegmentViewHeight   = selectedSegmentViewHeight
        segmentedScrollView.segmentTitleColor           = segmentTitleColor
        segmentedScrollView.segmentSelectedTitleColor   = segmentSelectedTitleColor
        segmentedScrollView.segmentBackgroundColor      = segmentBackgroundColor
        segmentedScrollView.segmentShadow               = segmentShadow
        segmentedScrollView.segmentTitleFont            = segmentTitleFont
        segmentedScrollView.segmentBounces              = segmentBounces
        segmentedScrollView.headerViewHeight            = headerViewHeight
        segmentedScrollView.headerViewOffsetHeight      = headerViewOffsetHeight
        segmentedScrollView.segmentViewHeight           = segmentViewHeight
        segmentedScrollView.backgroundColor             = segmentedScrollViewColor
        segmentedScrollView.sjDisableScrollOnContentView = disableScrollOnContentView
    }
    
    /**
     * Private method for adding the segmented scroll view.
     */
    func addSegmentedScrollView() {
        
        let topSpacing = SJUtil.getTopSpacing(self)
        segmentedScrollView.topSpacing = topSpacing
        
        let bottomSpacing = SJUtil.getBottomSpacing(self)
        segmentedScrollView.bottomSpacing = bottomSpacing
        
        view.addSubview(segmentedScrollView)
        
        let horizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[scrollView]-0-|",
                                                                                   options: [],
                                                                                   metrics: nil,
                                                                                   views: ["scrollView": segmentedScrollView])
        view.addConstraints(horizontalConstraints)
        
        let verticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:[scrollView]-bp-|",
                                                                                 options: [],
                                                                                 metrics: ["tp": topSpacing,
                                                                                    "bp": bottomSpacing],
                                                                                 views: ["scrollView": segmentedScrollView])
        view.addConstraints(verticalConstraints)
        
        segmentScrollViewTopConstraint = NSLayoutConstraint(item: segmentedScrollView,
                                                            attribute: .top,
                                                            relatedBy: .equal,
                                                            toItem: view,
                                                            attribute: .top,
                                                            multiplier: 1.0,
                                                            constant: topSpacing)
        view.addConstraint(segmentScrollViewTopConstraint!)
        
        segmentedScrollView.setContentView()
        
        // selected segment at index
        segmentedScrollView.didSelectSegmentAtIndex = {[unowned self] (segment, index, animated) in

            let selectedController = self.segmentControllers[index]
            self.delegate?.didMoveToPage?(selectedController, segment: segment!, index: index)
        }
    }
    
    /**
     Method for adding the HeaderViewController into the container
     
     - parameter headerViewController: Header ViewController.
     */
    func addHeaderViewController(_ headerViewController: UIViewController) {
        
        addChild(headerViewController)
        segmentedScrollView.addHeaderView(headerViewController.view)
        headerViewController.didMove(toParent: self)
    }
    
    /**
     Method for adding the array of content ViewControllers into the container
     
     - parameter contentControllers: array of ViewControllers
     */
    func addContentControllers(_ contentControllers: [UIViewController]) {
        segmentedScrollView.addSegmentView(contentControllers, frame: view.bounds)
        
        var index = 0
        for controller in contentControllers {
            
            addChild(controller)
            segmentedScrollView.addContentView(controller.view, frame: view.bounds)
            controller.didMove(toParent: self)
            
            let delegate = controller as? SJSegmentedViewControllerViewSource
            var observeView = controller.view

			if let collectionController = controller as? UICollectionViewController {
				observeView = collectionController.collectionView
			}

            if let view = delegate?.viewForSegmentControllerToObserveContentOffsetChange?() {
                observeView = view
            }

            segmentedScrollView.addObserverFor(observeView!)
            index += 1
        }
        
        segmentedScrollView.segmentView?.contentView = segmentedScrollView.contentView
    }
    
    /**
     * Method for loading content ViewControllers and header ViewController
     */
    func loadControllers() {
        
        if headerViewController == nil  {
            headerViewController = UIViewController()
			headerViewHeight = 0.0
        }
        
        addHeaderViewController(headerViewController!)
        addContentControllers(segmentControllers)
        
        //Delegate call for setting the first view of segments.
        var segment: SJSegmentTab?
        if segments.count > 0 {
            segment = segments[0]
        }
        
        delegate?.didMoveToPage?(segmentControllers[0],
                                 segment: segment,
                                 index: 0)
    }
}
