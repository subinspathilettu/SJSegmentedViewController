//
//  SJSegmentView.swift
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

typealias DidSelectSegmentAtIndex = (index: Int) -> Void

class SJSegmentView: UIScrollView {
    
    var selectedSegmentViewColor: UIColor? {
        didSet {
            self.selectedSegmentView?.backgroundColor = selectedSegmentViewColor
        }
    }
    
    var titleColor: UIColor? {
        didSet {
            for segment in self.segments {
                segment.setTitleColor(titleColor, for: UIControlState())
            }
        }
    }
    
    var segmentBackgroundColor: UIColor? {
        didSet {
            for segment in self.segments {
                segment.backgroundColor = segmentBackgroundColor
            }
        }
    }
    
    var font: UIFont?
    var selectedSegmentViewHeight: CGFloat?
    
    let kSegmentViewTagOffset = 100
    var segmentViewOffsetWidth: CGFloat = 10.0
    var titles: [String]?
    var segments = [UIButton]()
    var segmentContentView: UIView?
    var didSelectSegmentAtIndex: DidSelectSegmentAtIndex?
    var selectedSegmentView: UIView?
    var xPosConstraints: NSLayoutConstraint?
    var contentViewWidthConstraint: NSLayoutConstraint?
    var selectedSegmentViewWidthConstraint: NSLayoutConstraint?
    var contentSubViewWidthConstraints = [NSLayoutConstraint]()
    
    var contentView: SJContentView? {
        didSet {
            contentView!.addObserver(self,
                                     forKeyPath: "contentOffset",
                                     options: [NSKeyValueObservingOptions.new, NSKeyValueObservingOptions.old],
                                     context: nil)
        }
    }
    
    convenience init(frame: CGRect, segmentTitles: [String]) {
        self.init(frame: frame)
        
        self.titles = segmentTitles
        self.showsHorizontalScrollIndicator = false
        self.showsVerticalScrollIndicator = false
        self.bounces = false
    }
    
    required override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setSegmentsView() {
        
        let segmentWidth = self.getSegmentWidth(self.titles!)
        self.createSegmentContentView(self.titles!, titleWidth: segmentWidth)
        
        var index = 0
        for title in self.titles! {
            
            self.createSegmentFor(title, width: segmentWidth, index: index)
            index += 1
        }
        
        self.createSelectedSegmentView(segmentWidth)
    }
    
    func createSegmentContentView(_ titles: [String], titleWidth: CGFloat) {
        
        self.segmentContentView = UIView(frame: CGRect.zero)
        self.segmentContentView!.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.segmentContentView!)
        
        let contentViewWidth = titleWidth * CGFloat(titles.count)
        let horizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|[contentView]|",
                                                                                   options: [],
                                                                                   metrics: nil,
                                                                                   views: ["contentView": self.segmentContentView!,
                                                                                    "mainView": self])
        self.addConstraints(horizontalConstraints)
        
        contentViewWidthConstraint = NSLayoutConstraint(item: self.segmentContentView!,
                                                        attribute: .width,
                                                        relatedBy: .equal,
                                                        toItem: nil,
                                                        attribute: .notAnAttribute,
                                                        multiplier: 1.0,
                                                        constant: contentViewWidth)
        self.addConstraint(contentViewWidthConstraint!)
        
        
        let verticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|[contentView(==mainView)]|",
                                                                                 options: [],
                                                                                 metrics: nil,
                                                                                 views: ["contentView": self.segmentContentView!,
                                                                                    "mainView": self])
        self.addConstraints(verticalConstraints)
    }
    
    func createSegmentFor(_ title: String, width: CGFloat, index: Int) {
        
        let segmentView = self.getSegmentViewForController(title)
        segmentView.tag = (index + kSegmentViewTagOffset)
        segmentView.translatesAutoresizingMaskIntoConstraints = false
        self.segmentContentView!.addSubview(segmentView)
        
        if segments.count == 0 {
            
            let horizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|[view]",
                                                                                       options: [],
                                                                                       metrics: nil,
                                                                                       views: ["view": segmentView])
            self.segmentContentView!.addConstraints(horizontalConstraints)
            
        } else {
            
            let previousView = segments.last
            let horizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:[previousView]-0-[view]",
                                                                                       options: [],
                                                                                       metrics: nil,
                                                                                       views: ["view": segmentView,
                                                                                        "previousView": previousView!])
            self.segmentContentView!.addConstraints(horizontalConstraints)
        }
        
        let widthConstraint = NSLayoutConstraint(item: segmentView,
                                                 attribute: .width,
                                                 relatedBy: .equal,
                                                 toItem: nil,
                                                 attribute: .notAnAttribute,
                                                 multiplier: 1.0,
                                                 constant: width)
        self.segmentContentView!.addConstraint(widthConstraint)
        self.contentSubViewWidthConstraints.append(widthConstraint)
        
        let verticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|[view]|",
                                                                                 options: [],
                                                                                 metrics: nil,
                                                                                 views: ["view": segmentView])
        self.segmentContentView!.addConstraints(verticalConstraints)
        
        segments.append(segmentView)
    }
    
    func createSelectedSegmentView(_ width: CGFloat) {
        
        let segmentView = UIView()
        segmentView.backgroundColor = selectedSegmentViewColor
        segmentView.translatesAutoresizingMaskIntoConstraints = false
        self.segmentContentView!.addSubview(segmentView)
        self.selectedSegmentView = segmentView
        
        xPosConstraints = NSLayoutConstraint(item: segmentView,
                                             attribute: .leading,
                                             relatedBy: .equal,
                                             toItem: self.segmentContentView!,
                                             attribute: .leading,
                                             multiplier: 1.0,
                                             constant: 0.0)
        self.segmentContentView!.addConstraint(xPosConstraints!)
        
        let segment = self.segments.first
        let horizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:[view(==segment)]",
                                                                                   options: [],
                                                                                   metrics: nil,
                                                                                   views: ["view": segmentView,
                                                                                    "segment": segment!])
        self.segmentContentView!.addConstraints(horizontalConstraints)
        
        let verticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:[view(height)]|",
                                                                                 options: [],
                                                                                 metrics: ["height": selectedSegmentViewHeight!],
                                                                                 views: ["view": segmentView])
        self.segmentContentView!.addConstraints(verticalConstraints)
    }
    
    func getSegmentViewForController(_ title: String) -> UIButton {
        
        let button = UIButton(type: .custom)
        button.backgroundColor = segmentBackgroundColor
        button.setTitleColor(titleColor, for: UIControlState())
        button.setTitle(title, for: UIControlState())
        button.titleLabel?.font = font
        button.addTarget(self, action: #selector(SJSegmentView.onSegmentButtonPress(_:)),
                         for: .touchUpInside)
        return button
    }
    
    func onSegmentButtonPress(_ sender: AnyObject) {
        
        if self.didSelectSegmentAtIndex != nil {
            let index = sender.tag - kSegmentViewTagOffset
            self.didSelectSegmentAtIndex!(index: index)
        }
    }
    
    func getSegmentWidth(_ titles: [String]) -> CGFloat {
        
        var maxWidth: CGFloat = 0
        
        // find max width of segement
        for title in titles {
            
            let string: NSString = title
            let width = string.size(attributes: [NSFontAttributeName: self.font!]).width
            
            if width > maxWidth {
                maxWidth = width
            }
        }
        
        let width = Int(maxWidth + segmentViewOffsetWidth)
        let totalWidth = width * titles.count
        if totalWidth < Int(UIScreen.main().bounds.size.width)  {
            maxWidth = UIScreen.main().bounds.size.width /  CGFloat(titles.count)
        } else {
            maxWidth = CGFloat(width)
        }
        
        return maxWidth
    }
    
    override func observeValue(forKeyPath keyPath: String?,
                                                of object: AnyObject?,
                                                         change: [NSKeyValueChangeKey : AnyObject]?,
                                                         context: UnsafeMutablePointer<Void>?) {
        
        //update selected segment view x position
        let scrollView = object as? UIScrollView
        var changeOffset = (scrollView?.contentSize.width)! / self.contentSize.width
        let value = (scrollView?.contentOffset.x)! / changeOffset
        
        if !value.isNaN {
            selectedSegmentView?.frame.origin.x = (scrollView?.contentOffset.x)! / changeOffset
        }
        
        //update segment offset x position
        let segmentScrollWidth = self.contentSize.width - self.bounds.width
        let contentScrollWidth = scrollView!.contentSize.width - scrollView!.bounds.width
        changeOffset = segmentScrollWidth / contentScrollWidth
        self.contentOffset.x = (scrollView?.contentOffset.x)! * changeOffset
    }
    
    func didChangeParentViewFrame(_ frame: CGRect) {
        
        let segmentWidth = self.getSegmentWidth(self.titles!)
        let contentViewWidth = segmentWidth * CGFloat(self.titles!.count)
        contentViewWidthConstraint?.constant = contentViewWidth
        
        for constraint in self.contentSubViewWidthConstraints {
            constraint.constant = segmentWidth
        }
        
        self.layoutIfNeeded()
    }
}
