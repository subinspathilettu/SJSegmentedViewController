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
    var headerViewHeight: CGFloat?
    var segmentViewHeight: CGFloat?
    var headerViewOffsetHeight: CGFloat?
    var selectedSegmentViewColor: UIColor?
    var selectedSegmentViewHeight: CGFloat?
    var segmentTitleColor: UIColor?
    var segmentBackgroundColor: UIColor?
    var segmentTitleFont: UIFont?
    var topSpacing: CGFloat?
    var bottomSpacing: CGFloat?
    var observing = true
    var headerView: UIView?
    var contentControllers: [UIViewController]?
    var contentViews = [UIView]()
    var contentView: SJContentView?
    var scrollContentView: UIView!
    var contentViewHeightConstraint: NSLayoutConstraint!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.sizeToFit()
        self.translatesAutoresizingMaskIntoConstraints = false
        self.showsHorizontalScrollIndicator = false
        self.showsVerticalScrollIndicator = false
        self.bounces = false
        
        self.addObserver(self, forKeyPath: "contentOffset",
                         options: [NSKeyValueObservingOptions.New, NSKeyValueObservingOptions.Old],
                         context: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setContentView() {
        
        if scrollContentView == nil {
            
            scrollContentView = UIView()
            scrollContentView.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(scrollContentView)
            
            let horizontalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|[contentView(==mainView)]|",
                                                                                       options: [],
                                                                                       metrics: nil,
                                                                                       views: ["contentView": scrollContentView, "mainView": self])
            self.addConstraints(horizontalConstraints)
            
            let contentHeight = getContentHeight()
            let verticalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|[contentView]|",
                                                                                     options: [],
                                                                                     metrics: nil,
                                                                                     views: ["contentView": scrollContentView])
            self.addConstraints(verticalConstraints)
            
            contentViewHeightConstraint = NSLayoutConstraint(item: scrollContentView,
                                                             attribute: .Height,
                                                             relatedBy: .Equal,
                                                             toItem: nil,
                                                             attribute: .NotAnAttribute,
                                                             multiplier: 1.0,
                                                             constant: contentHeight)
            self.addConstraint(contentViewHeightConstraint)
        }
    }
    
    func addHeaderView(headerView: UIView?) {
        
        if headerView != nil {
            
            self.headerView = headerView
            self.headerView?.translatesAutoresizingMaskIntoConstraints = false
            self.headerView?.clipsToBounds = true
            scrollContentView.addSubview(self.headerView!)
            
            let horizontalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[headerView]-0-|",
                                                                                       options: [],
                                                                                       metrics: nil,
                                                                                       views: ["headerView": self.headerView!])
            scrollContentView.addConstraints(horizontalConstraints)
            
            let verticalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|[headerView(\(headerViewHeight!))]",
                                                                                     options: [],
                                                                                     metrics: nil,
                                                                                     views: ["headerView": self.headerView!])
            scrollContentView.addConstraints(verticalConstraints)
        } else {
            
            headerViewHeight = headerViewOffsetHeight
        }
    }
    
    func addObserverFor(view view: UIView) {
        
        view.addObserver(self, forKeyPath: "contentOffset",
                         options: [NSKeyValueObservingOptions.New, NSKeyValueObservingOptions.Old],
                         context: nil)
    }
    
    func addContentView(contentView: UIView) {
        
        if self.contentView == nil {
            self.contentView = createContentView()
        }
        
        self.contentViews.append(contentView)
        self.contentView?.addContentView(contentView)
    }
    
    func updateSubviewsFrame() {
        
        contentViewHeightConstraint.constant = getContentHeight()
        contentView?.layoutIfNeeded()
        
        self.segmentView?.didChangeParentViewFrame(self.frame)
        self.contentView?.updateContentControllersFrame()
    }
    
    //MARK: Private Functions
    
    func getContentHeight() -> CGFloat {
        
        var contentHeight = UIScreen.mainScreen().bounds.height + headerViewHeight!
        contentHeight -= (topSpacing! + bottomSpacing! + headerViewOffsetHeight!)
        return contentHeight
    }
    
    func addSegmentView(controllers: [UIViewController]) {
        
        if controllers.count > 1 {
            
            let titles = self.getSegmentTitlesFromControllers(controllers)
            self.segmentView = SJSegmentView(frame: CGRectZero,
                                             segmentTitles: titles)
            self.segmentView?.selectedSegmentViewColor = self.selectedSegmentViewColor
            self.segmentView?.selectedSegmentViewHeight = self.selectedSegmentViewHeight!
            self.segmentView?.titleColor = self.segmentTitleColor
            self.segmentView?.segmentBackgroundColor = self.segmentBackgroundColor
            self.segmentView?.font = self.segmentTitleFont!
            self.segmentView!.translatesAutoresizingMaskIntoConstraints = false
            self.segmentView!.didSelectSegmentAtIndex = {
                (index) in
                self.contentView?.movePageToIndex(index, animated: true)
            }
            
            self.segmentView?.setSegmentsView()
            self.addSubview(self.segmentView!)
            
            let horizontalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[segmentView]-0-|",
                                                                                       options: [],
                                                                                       metrics: nil,
                                                                                       views: ["segmentView": self.segmentView!])
            self.addConstraints(horizontalConstraints)
            
            let view = headerView == nil ? self : headerView
            let verticalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:[headerView]-0-[segmentView(\(segmentViewHeight!))]",
                                                                                     options: [],
                                                                                     metrics: nil,
                                                                                     views: ["headerView": view!,
                                                                                        "segmentView": self.segmentView!])
            self.addConstraints(verticalConstraints)
        } else {
            
            segmentViewHeight = 0.0
        }
    }
    
    func getSegmentTitlesFromControllers(controllers: [UIViewController]) -> [String] {
        
        var titles = [String]()
        
        for controller in controllers {
            if controller.title != nil  {
                titles.append(controller.title!)
            } else {
                titles.append("")
            }
        }
        
        return titles
    }
    
    func addSegmentsForContentViews(titles: [String]) {
        
        let frame = CGRect(x: 0, y: headerViewHeight!,
                           width: self.bounds.size.width, height: segmentViewHeight!)
        self.segmentView = SJSegmentView(frame: frame, segmentTitles: titles)
        self.segmentView!.didSelectSegmentAtIndex = {
            (index) in
            self.contentView?.movePageToIndex(index, animated: true)
        }
        self.addSubview(self.segmentView!)
    }
    
    func createContentView() -> SJContentView {
        
        let contentView = SJContentView(frame: CGRectZero, delegate: self)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollContentView.addSubview(contentView)
        
        let horizontalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[contentView]-0-|",
                                                                                   options: [],
                                                                                   metrics: nil,
                                                                                   views: ["contentView": contentView])
        scrollContentView.addConstraints(horizontalConstraints)
        
        let verticalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:[headerView]-\(segmentViewHeight!)-[contentView]-0-|",
                                                                                 options: [],
                                                                                 metrics: nil,
                                                                                 views: ["headerView": self.headerView!,
                                                                                    "contentView": contentView])
        scrollContentView.addConstraints(verticalConstraints)
        
        return contentView
    }
    
    func handleScrollUp(scrollView: UIScrollView,
                        change: CGFloat,
                        oldPosition: CGPoint) {
        
        if scrollView.contentOffset.y < 0.0 {
            if self.contentOffset.y >= 0.0 {
                
                var yPos = self.contentOffset.y - change
                yPos = yPos < 0 ? 0 : yPos
                let updatedPos = CGPoint(x: self.contentOffset.x, y: yPos)
                self.setContentOffset(self, point: updatedPos)
                self.setContentOffset(scrollView, point: oldPosition)
            }
        }
    }
    
    func handleScrollDown(scrollView: UIScrollView,
                          change: CGFloat,
                          oldPosition: CGPoint) {
        
        let offset = (headerViewHeight! - headerViewOffsetHeight!)
        
        if self.contentOffset.y < offset {
            
            if scrollView.contentOffset.y >= 0.0 {
                
                var yPos = self.contentOffset.y - change
                yPos = yPos > offset ? offset : yPos
                let updatedPos = CGPoint(x: self.contentOffset.x, y: yPos)
                self.setContentOffset(self, point: updatedPos)
                self.setContentOffset(scrollView, point: oldPosition)
            }
        }
    }
    
    override func observeValueForKeyPath(keyPath: String?,
                                                ofObject object: AnyObject?,
                                                         change: [String : AnyObject]?,
                                                         context: UnsafeMutablePointer<Void>) {
        
        if !observing { return }
        
        let scrollView = object as? UIScrollView
        if scrollView == nil { return }
        if scrollView == self { return }
        
        let new = change![NSKeyValueChangeNewKey]?.CGPointValue
        let old = change![NSKeyValueChangeOldKey]?.CGPointValue
        let diff = (old?.y)! - (new?.y)!
                
        if diff > 0.0 {
            
            self.handleScrollUp(scrollView!,
                                change: diff,
                                oldPosition: old!)
        } else {
            
            self.handleScrollDown(scrollView!,
                                  change: diff,
                                  oldPosition: old!)
        }
    }
    
    func setContentOffset(scrollView: UIScrollView, point: CGPoint) {
        observing = false
        scrollView.contentOffset = point
        observing = true
    }
}
