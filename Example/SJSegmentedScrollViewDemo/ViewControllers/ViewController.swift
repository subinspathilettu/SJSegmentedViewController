//
//  ViewController.swift
//  SJSegmentedScrollView
//
//  Created by Subins Jose on 06/10/2016.
//  Copyright © 2016 Subins Jose. All rights reserved.
//

import UIKit
import SJSegmentedScrollView

class ViewController: UIViewController {
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if let storyboard = self.storyboard {
            
            let headerViewController = storyboard
                .instantiateViewControllerWithIdentifier("HeaderViewController")
            
            let firstViewController = storyboard
                .instantiateViewControllerWithIdentifier("FirstTableViewController")
            firstViewController.title = "Table View"
            
            let secondViewController = storyboard
                .instantiateViewControllerWithIdentifier("SecondViewController")
            secondViewController.title = "Custom View"
            
            let thirdViewController = storyboard
                .instantiateViewControllerWithIdentifier("ThirdViewController")
            thirdViewController.title = "View"
            
            let segmentedViewController = SJSegmentedViewController(headerViewController: headerViewController,
                                                                    segmentControllers: [firstViewController,
                                                                        secondViewController,
                                                                        thirdViewController])
            segmentedViewController.selectedSegmentViewColor = UIColor.redColor()
            self.presentViewController(segmentedViewController, animated: false, completion: nil)
        }
    }
}