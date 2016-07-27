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
    var observer: SJSegmentedScrollView?
    var controllers = [UITableViewController]()
    var contentViews = [UIView]()
    var contentView: UIView!
    var contentViewWidthConstraint: NSLayoutConstraint!
    var contentSubViewWidthConstraints = [NSLayoutConstraint]()
    
    convenience init(frame: CGRect, delegate: SJSegmentedScrollView) {
        self.init(frame: frame)
        
        self.observer = delegate
        self.delegate = self
        self.isPagingEnabled = true
        self.showsVerticalScrollIndicator = true
        
        contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(contentView)
        
        let horizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|[contentView]|",
                                                                                   options: [],
                                                                                   metrics: nil,
                                                                                   views: ["contentView": contentView, "mainView": self])
        self.addConstraints(horizontalConstraints)
        
        contentViewWidthConstraint = NSLayoutConstraint(item: contentView,
                                                        attribute: .width,
                                                        relatedBy: .equal,
                                                        toItem: nil,
                                                        attribute: .notAnAttribute,
                                                        multiplier: 1.0,
                                                        constant: 0)
        self.addConstraint(contentViewWidthConstraint)
        
        let verticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|[contentView(==mainView)]|",
                                                                                 options: [],
                                                                                 metrics: nil,
                                                                                 views: ["contentView": contentView, "mainView": self])
        self.addConstraints(verticalConstraints)
    }
    
    func addContentViews(_ contentViewControllers: [UITableViewController]) {
        
        self.controllers = contentViewControllers
        
        for controller in contentViewControllers {
            self.addContentView(controller.view)
        }
    }
    
    func addContentView(_ view: UIView) {
        
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        
        let width = Int(UIScreen.main().bounds.size.width)
        if self.contentViews.count > 0 {
            
            let previousView = self.contentViews.last
            let horizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:[previousView]-0-[view]",
                                                                                       options: [],
                                                                                       metrics: ["xPos": (self.contentViews.count * width)],
                                                                                       views: ["view": view, "previousView": previousView!])
            contentView.addConstraints(horizontalConstraints)
        } else {
            
            let horizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|[view]",
                                                                                       options: [],
                                                                                       metrics: ["xPos": (self.contentViews.count * width)],
                                                                                       views: ["view": view])
            contentView.addConstraints(horizontalConstraints)
        }
        
        let widthConstraint = NSLayoutConstraint(item: view,
                                                 attribute: .width,
                                                 relatedBy: .equal,
                                                 toItem: nil,
                                                 attribute: .notAnAttribute,
                                                 multiplier: 1.0,
                                                 constant: CGFloat(width))
        contentView.addConstraint(widthConstraint)
        self.contentSubViewWidthConstraints.append(widthConstraint)
        
        let verticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[view]-0-|",
                                                                                 options: [],
                                                                                 metrics: nil,
                                                                                 views: ["view": view])
        contentView.addConstraints(verticalConstraints)
        self.contentViews.append(view)
        
        contentViewWidthConstraint.constant = CGFloat(self.contentViews.count) * UIScreen.main().bounds.width
    }
    
    func updateContentControllersFrame() {
        
        let width = UIScreen.main().bounds.width
        contentViewWidthConstraint.constant = CGFloat(self.contentViews.count) * width
        
        for constraint in self.contentSubViewWidthConstraints {
            constraint.constant = width
        }
        
        var point = self.contentOffset
        point.x = CGFloat(self.pageIndex) * width
        self.setContentOffset(point, animated: true)
        self.layoutIfNeeded()
    }
    
    required override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func movePageToIndex(_ index: Int, animated: Bool) {
        
        self.pageIndex = index
        let point = CGPoint(x: (index * Int(self.bounds.size.width)), y: 0)
        self.setContentOffset(point, animated: animated)
    }
}

extension SJContentView: UIScrollViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.pageIndex = Int(self.contentOffset.x / self.bounds.size.width)
    }
}
