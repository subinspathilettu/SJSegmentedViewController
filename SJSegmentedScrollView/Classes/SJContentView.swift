//
//  SJContentView.swift
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

class SJContentView: UIScrollView {
    
    var pageIndex = 0
    var contentViews = [UIView]()
    var contentView: UIView!
    var contentViewWidthConstraint: NSLayoutConstraint!
    var contentSubViewWidthConstraints = [NSLayoutConstraint]()
    let animationDuration = 0.3
    var didSelectSegmentAtIndex: DidSelectSegmentAtIndex?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        delegate = self
        self.pagingEnabled = true
   //     isPagingEnabled = true
        showsVerticalScrollIndicator = false
        
        contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(contentView)
        
        let horizontalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|[contentView]|",
                                                                                   options: [],
                                                                                   metrics: nil,
                                                                                   views: ["contentView": contentView, "mainView": self])
        addConstraints(horizontalConstraints)
        

        contentViewWidthConstraint = NSLayoutConstraint(item: contentView,
                                                        attribute: .Width,
                                                        relatedBy: .Equal,
                                                        toItem: nil,
                                                        attribute: .NotAnAttribute,
                                                        multiplier: 1.0,
                                                        constant: 0)
        addConstraint(contentViewWidthConstraint)
        
        let verticalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|[contentView(==mainView)]|",
                                                                                options: [],
                                                                                metrics: nil,
                                                                                views: ["contentView": contentView, "mainView": self])
        addConstraints(verticalConstraints)
    }
    
    func addContentView(_ view: UIView, frame: CGRect) {
        
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        
        let width = Int(frame.size.width)
        if contentViews.count > 0 {
            
            let previousView = contentViews.last
            let horizontalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:[previousView]-0-[view]",
                                                                                       options: [],
                                                                                       metrics: ["xPos": (self.contentViews.count * width)],
                                                                                       views: ["view": view, "previousView": previousView!])
            contentView.addConstraints(horizontalConstraints)
        } else {
            

            let horizontalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|[view]",
                                                                                       options: [],
                                                                                       metrics: ["xPos": (self.contentViews.count * width)],
                                                                                       views: ["view": view])
            contentView.addConstraints(horizontalConstraints)
        }
        
        let widthConstraint = NSLayoutConstraint(item: view,
                                                 attribute: .Width,
                                                 relatedBy: .Equal,
                                                 toItem: nil,
                                                 attribute: .NotAnAttribute,
                                                 multiplier: 1.0,
                                                 constant: CGFloat(width))
        contentView.addConstraint(widthConstraint)
        contentSubViewWidthConstraints.append(widthConstraint)
        
        let verticalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[view]-0-|",
                                                                                 options: [],
                                                                                 metrics: nil,
                                                                                 views: ["view": view])
        contentView.addConstraints(verticalConstraints)
        contentViews.append(view)
        
        contentViewWidthConstraint.constant = CGFloat(contentViews.count) * bounds.width
    }
    
    func updateContentControllersFrame(_ frame: CGRect) {
        
        let width = frame.size.width
        contentViewWidthConstraint.constant = CGFloat(contentViews.count) * width
        
        for constraint in contentSubViewWidthConstraints {
            constraint.constant = width
        }
        
        layoutIfNeeded()
        var point = contentOffset
        point.x = CGFloat(pageIndex) * width
        setContentOffset(point, animated: true)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func movePageToIndex(_ index: Int, animated: Bool) {
        
        pageIndex = index
        let point = CGPoint(x: (index * Int(bounds.size.width)), y: 0)
        
        if animated == true {
            UIView.animateWithDuration(animationDuration) {
                self.contentOffset = point
            }
        }
            else {
            contentOffset = point
        }
    }
}

extension SJContentView: UIScrollViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
       self.pageIndex = Int(contentOffset.x / bounds.size.width)
        didSelectSegmentAtIndex?(segment: nil, index: pageIndex)
        
        NSNotificationCenter.defaultCenter().postNotificationName("DidChangeSegmentIndex",
                                                                  object: pageIndex)

    }
}
