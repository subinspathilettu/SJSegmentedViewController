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
        self.title = "Segment"
    }
    
    //MARK:- Private Function
    //MARK:-
    
    func getSJSegmentedViewController() -> SJSegmentedViewController? {
        
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
            segmentedViewController.headerViewHeight = 200.0
            segmentedViewController.selectedSegmentViewColor = UIColor.redColor()
            segmentedViewController.segmentViewHeight = 60.0
            return segmentedViewController
        }
        
        return nil
    }
    
    //MARK:- Actions
    //MARK:-
    @IBAction func presentViewController() {
        
        let viewController = getSJSegmentedViewController()
        
        if viewController != nil {
            self.presentViewController(viewController!,
                                       animated: true,
                                       completion: nil)
        }
    }
    
    @IBAction func pushViewController() {
        
        let viewController = getSJSegmentedViewController()
        
        if viewController != nil {
            self.navigationController?.pushViewController(viewController!,
                                                          animated: true)
        }
    }
    
    @IBAction func adddChildViewController() {
        
        let viewController = getSJSegmentedViewController()
        
        if viewController != nil {
            addChildViewController(viewController!)
            self.view.addSubview(viewController!.view)
            viewController!.view.frame = self.view.bounds
            viewController!.didMoveToParentViewController(self)
        }
    }
}