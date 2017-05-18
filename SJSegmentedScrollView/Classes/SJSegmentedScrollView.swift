//
//  SJSegmentedScrollView.swift
//  SJSegmentedScrollView
//
//  Created by Subins Jose on 10/06/16.
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

class SJSegmentedScrollView: UIScrollView {
    
    var segmentView: SJSegmentView?
    var headerViewHeight: CGFloat! = 0
    var segmentViewHeight: CGFloat! = 0
    var headerViewOffsetHeight: CGFloat! = 0
    var selectedSegmentViewColor: UIColor! = UIColor.red
    var selectedSegmentViewHeight: CGFloat! = 0
    var segmentBounces = false
    var segmentTitleColor: UIColor! = UIColor.red
    var selectedSegmentTitleColor: UIColor?
    var segmentBackgroundColor: UIColor?
    var segmentShadow: SJShadow?
    var segmentTitleFont: UIFont! = UIFont.systemFont(ofSize: 12)
    var topSpacing: CGFloat?
    var bottomSpacing: CGFloat?
    var observing = true
    var headerView: UIView?
    var contentControllers: [UIViewController]?
    var contentViews = [UIView]()
    var contentView: SJContentView?
    var scrollContentView: UIView!
    var contentViewHeightConstraint: NSLayoutConstraint!
    var didSelectSegmentAtIndex: DidSelectSegmentAtIndex?
	var sjShowsVerticalScrollIndicator: Bool = false {
		didSet {
			showsVerticalScrollIndicator = sjShowsVerticalScrollIndicator
			contentView?.showsVerticalScrollIndicator = sjShowsVerticalScrollIndicator
		}
	}
	var sjShowsHorizontalScrollIndicator: Bool = false  {
		didSet {
			showsHorizontalScrollIndicator = sjShowsHorizontalScrollIndicator
			contentView?.showsHorizontalScrollIndicator = sjShowsHorizontalScrollIndicator
		}
	}

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        sizeToFit()
        translatesAutoresizingMaskIntoConstraints = false
        showsHorizontalScrollIndicator = sjShowsHorizontalScrollIndicator
        showsVerticalScrollIndicator = sjShowsVerticalScrollIndicator
		decelerationRate = UIScrollViewDecelerationRateFast
        bounces = false
        
        addObserver(self, forKeyPath: "contentOffset",
                         options: [NSKeyValueObservingOptions.new, NSKeyValueObservingOptions.old],
                         context: nil)
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        removeObserver(self,
                            forKeyPath: "contentOffset",
                            context: nil)
    }
    
    func setContentView() {
        
        if scrollContentView == nil {
            
            scrollContentView = UIView()
            scrollContentView.translatesAutoresizingMaskIntoConstraints = false
            addSubview(scrollContentView)
            
            let horizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|[contentView(==mainView)]|",
                                                                                       options: [],
                                                                                       metrics: nil,
                                                                                       views: ["contentView": scrollContentView, "mainView": self])
            addConstraints(horizontalConstraints)
            
            let contentHeight = getContentHeight()
            let verticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|[contentView]|",
                                                                                     options: [],
                                                                                     metrics: nil,
                                                                                     views: ["contentView": scrollContentView])
            addConstraints(verticalConstraints)
            
            contentViewHeightConstraint = NSLayoutConstraint(item: scrollContentView,
                                                             attribute: .height,
                                                             relatedBy: .equal,
                                                             toItem: nil,
                                                             attribute: .notAnAttribute,
                                                             multiplier: 1.0,
                                                             constant: contentHeight)
            addConstraint(contentViewHeightConstraint)
        }
    }
    
    func addHeaderView(_ headerView: UIView?) {
        
        if headerView != nil {
            
            self.headerView = headerView
            headerView?.translatesAutoresizingMaskIntoConstraints = false
            scrollContentView.addSubview(headerView!)
            
            let horizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[headerView]-0-|",
                                                                                       options: [],
                                                                                       metrics: nil,
                                                                                       views: ["headerView": headerView!])
            scrollContentView.addConstraints(horizontalConstraints)
            
            let verticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|[headerView(\(headerViewHeight!))]",
                                                                                     options: [],
                                                                                     metrics: nil,
                                                                                     views: ["headerView": headerView!])
            scrollContentView.addConstraints(verticalConstraints)
        } else {
            
            headerViewHeight = headerViewOffsetHeight
        }
    }
    
    func addObserverFor(_ view: UIView) {
        
        view.addObserver(self, forKeyPath: "contentOffset",
                         options: [NSKeyValueObservingOptions.new, NSKeyValueObservingOptions.old],
                         context: nil)
    }
    
    func addContentView(_ contentView: UIView, frame: CGRect) {
        
        if self.contentView == nil {
            self.contentView = createContentView()
        }
        
        contentViews.append(contentView)
        self.contentView?.addContentView(contentView, frame: frame)
        self.contentView!.didSelectSegmentAtIndex = {
            (segment, index, animated) in
            self.didSelectSegmentAtIndex?(self.segmentView!.segments[index], index, animated)
        }
    }
    
    func updateSubviewsFrame(_ frame: CGRect) {
        
        contentViewHeightConstraint.constant = getContentHeight()
        contentView?.layoutIfNeeded()
        
        segmentView?.didChangeParentViewFrame(frame)
        contentView?.updateContentControllersFrame(frame)
    }
    
    //MARK: Private Functions
    func getContentHeight() -> CGFloat {
		
        var contentHeight = (superview?.bounds.height)! + headerViewHeight!
        contentHeight -= (topSpacing! + bottomSpacing! + headerViewOffsetHeight!)
        return contentHeight
    }
    
    func addSegmentView(_ controllers: [UIViewController], frame: CGRect) {
        
        if controllers.count > 1 {
            
            segmentView = SJSegmentView(frame: CGRect.zero)
			segmentView?.controllers					= controllers
            segmentView?.selectedSegmentViewColor		= selectedSegmentViewColor
            segmentView?.selectedSegmentViewHeight		= selectedSegmentViewHeight!
            segmentView?.titleColor						= segmentTitleColor
            segmentView?.segmentBackgroundColor			= segmentBackgroundColor
            segmentView?.font							= segmentTitleFont!
            segmentView?.shadow							= segmentShadow
            segmentView?.font							= segmentTitleFont!
            segmentView?.bounces						= segmentBounces
            segmentView!.translatesAutoresizingMaskIntoConstraints = false
            segmentView!.didSelectSegmentAtIndex = {
                (segment, index, animated) in
                self.contentView?.movePageToIndex(index, animated: animated)
                self.didSelectSegmentAtIndex?(segment, index, animated)
            }
            
            segmentView?.setSegmentsView(frame)
            addSubview(segmentView!)
            
            let horizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[segmentView]-0-|",
                                                                                       options: [],
                                                                                       metrics: nil,
                                                                                       views: ["segmentView": segmentView!])
            addConstraints(horizontalConstraints)
            
            let view = headerView == nil ? self : headerView
            let verticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:[headerView]-0-[segmentView(\(segmentViewHeight!))]",
                                                                                     options: [],
                                                                                     metrics: nil,
                                                                                     views: ["headerView": view!,
                                                                                        "segmentView": segmentView!])
            addConstraints(verticalConstraints)
        } else {
            
            segmentViewHeight = 0.0
        }
    }
    
    func addSegmentsForContentViews(_ titles: [String]) {
        
        let frame = CGRect(x: 0, y: headerViewHeight!,
                           width: bounds.size.width, height: segmentViewHeight!)
        segmentView = SJSegmentView(frame: frame)
        segmentView!.didSelectSegmentAtIndex = {
            (segment, index, animated) in
            self.contentView?.movePageToIndex(index, animated: animated)
        }
        addSubview(segmentView!)
    }
    
    func createContentView() -> SJContentView {
        
        let contentView = SJContentView(frame: CGRect.zero)
		contentView.showsVerticalScrollIndicator = sjShowsVerticalScrollIndicator
		contentView.showsHorizontalScrollIndicator = sjShowsHorizontalScrollIndicator
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollContentView.addSubview(contentView)
        
        let horizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[contentView]-0-|",
                                                                                   options: [],
                                                                                   metrics: nil,
                                                                                   views: ["contentView": contentView])
        scrollContentView.addConstraints(horizontalConstraints)
        
        let verticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:[headerView]-\(segmentViewHeight!)-[contentView]-0-|",
                                                                                 options: [],
                                                                                 metrics: nil,
                                                                                 views: ["headerView": headerView!,
                                                                                    "contentView": contentView])

        
        scrollContentView.addConstraints(verticalConstraints)
        return contentView
    }
    
    func handleScrollUp(_ scrollView: UIScrollView,
                        change: CGFloat,
                        oldPosition: CGPoint) {

		if headerViewHeight != 0.0 && contentOffset.y != 0.0 {
			if scrollView.contentOffset.y < 0.0 {
				if contentOffset.y >= 0.0 {

					var yPos = contentOffset.y - change
					yPos = yPos < 0 ? 0 : yPos
					let updatedPos = CGPoint(x: contentOffset.x, y: yPos)
					setContentOffset(self, point: updatedPos)
					setContentOffset(scrollView, point: oldPosition)
				}
			}
		}
    }

    func handleScrollDown(_ scrollView: UIScrollView,
                          change: CGFloat,
                          oldPosition: CGPoint) {
        
        let offset = (headerViewHeight! - headerViewOffsetHeight!)
        
        if contentOffset.y < offset {
            
            if scrollView.contentOffset.y >= 0.0 {
                
                var yPos = contentOffset.y - change
                yPos = yPos > offset ? offset : yPos
                let updatedPos = CGPoint(x: contentOffset.x, y: yPos)
                setContentOffset(self, point: updatedPos)
                setContentOffset(scrollView, point: oldPosition)
            }
        }
    }

	override func observeValue(forKeyPath keyPath: String?,
	                           of object: Any?,
	                           change: [NSKeyValueChangeKey : Any]?,
	                           context: UnsafeMutableRawPointer?) {
		if !observing { return }

		let scrollView = object as? UIScrollView
		if scrollView == nil { return }
		if scrollView == self { return }

		let changeValues = change! as [NSKeyValueChangeKey: AnyObject]

		if let new = changeValues[NSKeyValueChangeKey.newKey]?.cgPointValue,
			let old = changeValues[NSKeyValueChangeKey.oldKey]?.cgPointValue {

			let diff = old.y - new.y

			if diff > 0.0 {

				handleScrollUp(scrollView!,
				                    change: diff,
				                    oldPosition: old)
			} else {

				handleScrollDown(scrollView!,
				                      change: diff,
				                      oldPosition: old)
			}
		}
	}

    func setContentOffset(_ scrollView: UIScrollView, point: CGPoint) {
        observing = false
        scrollView.contentOffset = point
        observing = true
    }
}
