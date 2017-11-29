//
//  SJUtil.swift
//  SJSegmentedScrollView
//
//  Created by Priya on 8/26/16.
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

class SJUtil {

    /**
     * Method to get topspacing of container,

     - returns: topspace in float
     */
    static func getTopSpacing(_ viewController: UIViewController) -> CGFloat {

        if let _ = viewController.splitViewController {
            return 0
        }

		var topSpacing: CGFloat = 0.0
		let navigationController = viewController.navigationController

		if navigationController?.childViewControllers.last == viewController {

			if navigationController?.isNavigationBarHidden == false {
				topSpacing = UIApplication.shared.statusBarFrame.height
                if !(navigationController?.navigationBar.isOpaque)! {
                    topSpacing += (navigationController?.navigationBar.bounds.height)!
                }
			}
		}
		
        return topSpacing
    }

    /**
     * Method to get bottomspacing of container

     - returns: bottomspace in float
     */
    static func getBottomSpacing(_ viewController: UIViewController) -> CGFloat {

        var bottomSpacing: CGFloat = 0.0

        if let tabBarController = viewController.tabBarController {
            if !tabBarController.tabBar.isHidden && !tabBarController.tabBar.isOpaque {
                bottomSpacing += tabBarController.tabBar.bounds.size.height
            }
        }

        return bottomSpacing
    }
}

extension String {
	
	func widthWithConstrainedWidth(_ width: CGFloat, font: UIFont) -> CGFloat {

		let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
		let boundingBox = self.boundingRect(with: constraintRect,
		                                    options: .usesLineFragmentOrigin,
		                                    attributes: [NSAttributedStringKey.font: font], context: nil)
		return boundingBox.width
	}
}
