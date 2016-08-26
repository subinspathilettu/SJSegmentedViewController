//
//  SJUtil.swift
//  Pods
//
//  Created by Priya on 8/26/16.
//
//

import UIKit

class SJUtil {

    /**
     * Method to get topspacing of container,

     - returns: topspace in float
     */
    static func getTopSpacing(viewController: UIViewController) -> CGFloat {


        if let _ = viewController.splitViewController {
            return 0
        }

        var topSpacing = UIApplication.sharedApplication().statusBarFrame.size.height

        if let navigationController = viewController.navigationController {
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
    static func getBottomSpacing(viewController: UIViewController) -> CGFloat {

        var bottomSpacing: CGFloat = 0.0

        if let tabBarController = viewController.tabBarController {
            if !tabBarController.tabBar.hidden {
                bottomSpacing += tabBarController.tabBar.bounds.size.height
            }
        }

        return bottomSpacing
    }

    
}
