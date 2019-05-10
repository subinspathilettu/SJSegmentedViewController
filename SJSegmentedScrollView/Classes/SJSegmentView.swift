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

class SJSegmentView: UIScrollView {
    
    var selectedSegmentViewColor: UIColor? {
        didSet {
            selectedSegmentView?.backgroundColor = selectedSegmentViewColor
        }
    }
    
    var titleColor: UIColor? {
        didSet {
            for segment in segments {
                segment.titleColor(titleColor!)
            }
        }
    }
    
    var selectedTitleColor: UIColor? {
        didSet {
            for segment in segments {
                segment.selectedTitleColor(selectedTitleColor)
            }
        }
    }
    
    var segmentBackgroundColor: UIColor? {
        didSet {
            for segment in segments {
                segment.backgroundColor = segmentBackgroundColor
            }
        }
    }
    
    var shadow: SJShadow? {
        didSet {
            if let shadow = shadow {
                layer.shadowOffset = shadow.offset
                layer.shadowColor = shadow.color.cgColor
                layer.shadowRadius = shadow.radius
                layer.shadowOpacity = shadow.opacity
                layer.masksToBounds = false;
            }
        }
    }
    
    var font: UIFont?
    var selectedSegmentViewHeight: CGFloat?
    let kSegmentViewTagOffset = 100
    var segmentViewOffsetWidth: CGFloat = 10.0
    var segments = [SJSegmentTab]()
    var segmentContentView: UIView?
    var didSelectSegmentAtIndex: DidSelectSegmentAtIndex?
    var selectedSegmentView: UIView?
    var xPosConstraints: NSLayoutConstraint?
    var contentViewWidthConstraint: NSLayoutConstraint?
    var selectedSegmentViewWidthConstraint: NSLayoutConstraint?
    var contentSubViewWidthConstraints = [NSLayoutConstraint]()
	var controllers: [UIViewController]?
    
    var contentView: SJContentView? {
        didSet {
            contentView!.addObserver(self,
                                     forKeyPath: "contentOffset",
                                     options: [NSKeyValueObservingOptions.new, NSKeyValueObservingOptions.old],
                                     context: nil)
        }
    }
    
    required override init(frame: CGRect) {
        super.init(frame: frame)

		showsHorizontalScrollIndicator = false
		showsVerticalScrollIndicator = false
		bounces = false


		NotificationCenter.default.addObserver(self,
		                                       selector: #selector(SJSegmentView.didChangeSegmentIndex(_:)),
		                                       name: NSNotification.Name("DidChangeSegmentIndex"),
		                                       object: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        contentView!.removeObserver(self,
                                    forKeyPath: "contentOffset",
                                    context: nil)
        
        NotificationCenter.default.removeObserver(self,
                                                            name:NSNotification.Name("DidChangeSegmentIndex"),
                                                            object: nil)
    }
    
    @objc func didChangeSegmentIndex(_ notification: Notification) {
        
        //deselect previous buttons
        for button in segments {
            button.isSelected = false
        }
        
        // select current button
        let index = notification.object as? Int

		if index! < segments.count {
			let button = segments[index!]
			button.isSelected = true
		}
    }

    func setSegmentsView(_ frame: CGRect) {

        let segmentWidth = widthForSegment(frame)
        createSegmentContentView(segmentWidth)
        
        var index = 0
        for controller in controllers! {
            
            createSegmentFor(controller, width: segmentWidth, index: index)
            index += 1
        }
        
        createSelectedSegmentView(segmentWidth)
        
        //Set first button as selected
        let button = segments.first!
        button.isSelected = true
    }
    
    func createSegmentContentView(_ titleWidth: CGFloat) {
        
        segmentContentView = UIView(frame: CGRect.zero)
        segmentContentView!.translatesAutoresizingMaskIntoConstraints = false
        addSubview(segmentContentView!)
        
        let contentViewWidth = titleWidth * CGFloat((controllers?.count)!)
        let horizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|[contentView]|",
                                                                                   options: [],
                                                                                   metrics: nil,
                                                                                   views: ["contentView": segmentContentView!,
                                                                                    "mainView": self])
        addConstraints(horizontalConstraints)
        
        contentViewWidthConstraint = NSLayoutConstraint(item: segmentContentView!,
                                                        attribute: .width,
                                                        relatedBy: .equal,
                                                        toItem: nil,
                                                        attribute: .notAnAttribute,
                                                        multiplier: 1.0,
                                                        constant: contentViewWidth)
        addConstraint(contentViewWidthConstraint!)
        
        
        let verticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|[contentView(==mainView)]|",
                                                                                 options: [],
                                                                                 metrics: nil,
                                                                                 views: ["contentView": segmentContentView!,
                                                                                    "mainView": self])
        addConstraints(verticalConstraints)
    }
    
    func createSegmentFor(_ controller: UIViewController, width: CGFloat, index: Int) {
        
        let segmentView = getSegmentTabForController(controller)
        segmentView.tag = (index + kSegmentViewTagOffset)
        segmentView.translatesAutoresizingMaskIntoConstraints = false
        segmentContentView!.addSubview(segmentView)
        
        if segments.count == 0 {
            
            let horizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|[view]",
                                                                                       options: [],
                                                                                       metrics: nil,
                                                                                       views: ["view": segmentView])
            segmentContentView!.addConstraints(horizontalConstraints)
            
        } else {
            
            let previousView = segments.last
            let horizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:[previousView]-0-[view]",
                                                                                       options: [],
                                                                                       metrics: nil,
                                                                                       views: ["view": segmentView,
                                                                                        "previousView": previousView!])
            segmentContentView!.addConstraints(horizontalConstraints)
        }
        
        let widthConstraint = NSLayoutConstraint(item: segmentView,
                                                 attribute: .width,
                                                 relatedBy: .equal,
                                                 toItem: nil,
                                                 attribute: .notAnAttribute,
                                                 multiplier: 1.0,
                                                 constant: width)
        segmentContentView!.addConstraint(widthConstraint)
        contentSubViewWidthConstraints.append(widthConstraint)
        
        let verticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|[view]|",
                                                                                 options: [],
                                                                                 metrics: nil,
                                                                                 views: ["view": segmentView])
        segmentContentView!.addConstraints(verticalConstraints)
        segments.append(segmentView)
    }
    
    func createSelectedSegmentView(_ width: CGFloat) {
        
        let segmentView = UIView()
        segmentView.backgroundColor = selectedSegmentViewColor
        segmentView.translatesAutoresizingMaskIntoConstraints = false
        segmentContentView!.addSubview(segmentView)
        selectedSegmentView = segmentView
        
        xPosConstraints = NSLayoutConstraint(item: segmentView,
                                             attribute: .leading,
                                             relatedBy: .equal,
                                             toItem: segmentContentView!,
                                             attribute: .leading,
                                             multiplier: 1.0,
                                             constant: 0.0)
        segmentContentView!.addConstraint(xPosConstraints!)
        
        let segment = segments.first
        let horizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:[view(==segment)]",
                                                                                   options: [],
                                                                                   metrics: nil,
                                                                                   views: ["view": segmentView,
                                                                                    "segment": segment!])
        segmentContentView!.addConstraints(horizontalConstraints)
        
        let verticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:[view(height)]|",
                                                                                 options: [],
                                                                                 metrics: ["height": selectedSegmentViewHeight!],
                                                                                 views: ["view": segmentView])
        segmentContentView!.addConstraints(verticalConstraints)
    }
    
    func getSegmentTabForController(_ controller: UIViewController) -> SJSegmentTab {

		var segmentTab: SJSegmentTab?

		if controller.navigationItem.titleView != nil {
			segmentTab = SJSegmentTab.init(view: controller.navigationItem.titleView!)
		} else {

			if let title = controller.title {
				segmentTab = SJSegmentTab.init(title: title)
			} else {
				segmentTab = SJSegmentTab.init(title: "")
			}

			segmentTab?.backgroundColor = segmentBackgroundColor
			segmentTab?.titleColor(titleColor!)
            segmentTab?.selectedTitleColor(selectedTitleColor!)
			segmentTab?.titleFont(font!)
		}

		segmentTab?.didSelectSegmentAtIndex = didSelectSegmentAtIndex

        return segmentTab!
    }

	func widthForSegment(_ frame: CGRect) -> CGFloat {

		var maxWidth: CGFloat = 0
		for controller in controllers! {

			var width: CGFloat = 0.0
			if let view = controller.navigationItem.titleView {
				width = view.bounds.width
			} else if let title = controller.title {

				width = title.widthWithConstrainedWidth(.greatestFiniteMagnitude,
				                                        font: font!)
			}

			if width > maxWidth {
				maxWidth = width
			}
		}

		let width = Int(maxWidth + segmentViewOffsetWidth)
		let totalWidth = width * (controllers?.count)!
		if totalWidth < Int(frame.size.width)  {
			maxWidth = frame.size.width /  CGFloat((controllers?.count)!)
		} else {
			maxWidth = CGFloat(width)
		}

		return maxWidth
	}
    
	override func observeValue(forKeyPath keyPath: String?,
	                           of object: Any?,
	                           change: [NSKeyValueChangeKey : Any]?,
	                           context: UnsafeMutableRawPointer?) {
        
        if let change = change as [NSKeyValueChangeKey : AnyObject]? {
            if let old = change[NSKeyValueChangeKey.oldKey], let new = change[NSKeyValueChangeKey.newKey] {
                if !(old.isEqual(new)) {
                    //update selected segment view x position
                    let scrollView = object as? UIScrollView
                    var changeOffset = (scrollView?.contentSize.width)! / contentSize.width
                    let value = (scrollView?.contentOffset.x)! / changeOffset
                    
                    if !value.isNaN {
                        selectedSegmentView?.frame.origin.x = (scrollView?.contentOffset.x)! / changeOffset
                    }
                    
                    //update segment offset x position
                    let segmentScrollWidth = contentSize.width - bounds.width
                    let contentScrollWidth = scrollView!.contentSize.width - scrollView!.bounds.width
                    changeOffset = segmentScrollWidth / contentScrollWidth
                    contentOffset.x = (scrollView?.contentOffset.x)! * changeOffset
                }
            }
        }
    }
    
    func didChangeParentViewFrame(_ frame: CGRect) {
        
        let segmentWidth = widthForSegment(frame)
        let contentViewWidth = segmentWidth * CGFloat((controllers?.count)!)
        contentViewWidthConstraint?.constant = contentViewWidth
        
        for constraint in contentSubViewWidthConstraints {
            constraint.constant = segmentWidth
        }
        
        let changeOffset = (contentView?.contentSize.width)! / contentSize.width
        let value = (contentView?.contentOffset.x)! / changeOffset
        
        if !value.isNaN {
            if UIView.userInterfaceLayoutDirection(for: self.semanticContentAttribute) == .rightToLeft {
                let newIndex = contentView?.pageIndex ?? 0
                xPosConstraints!.constant = CGFloat(newIndex) * segmentWidth
            } else {
                xPosConstraints!.constant = (selectedSegmentView?.frame.origin.x)!
            }
            
            layoutIfNeeded()
        }
    }
}
