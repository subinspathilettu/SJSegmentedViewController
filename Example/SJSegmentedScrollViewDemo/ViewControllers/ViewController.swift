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
    
    let segmentedViewController = SJSegmentedViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBarHidden = false
        adddChildViewController()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.title = "Segment"
    }
    
    //MARK:- Private Function
    //MARK:-
    
    func getSJSegmentedViewController() -> SJSegmentedViewController? {
        
        if let storyboard = self.storyboard {
            
            let headerViewController = storyboard
                .instantiateViewControllerWithIdentifier("HeaderViewController1")

            let firstViewController = storyboard
                .instantiateViewControllerWithIdentifier("FirstTableViewController")
            firstViewController.title = "Table View"
            
            let secondViewController = storyboard
                .instantiateViewControllerWithIdentifier("SecondViewController")
            secondViewController.title = "Custom View"
            
            let thirdViewController = storyboard
                .instantiateViewControllerWithIdentifier("ThirdViewController")
            thirdViewController.title = "View"
            
            segmentedViewController.headerViewController = headerViewController
            segmentedViewController.segmentControllers = [firstViewController,
                                                          secondViewController,
                                                          thirdViewController]
            segmentedViewController.headerViewHeight = 200
            
            segmentedViewController.selectedSegmentViewColor = UIColor.redColor()
            segmentedViewController.segmentViewHeight = 60.0
            segmentedViewController.segmentShadow = SJShadow.light()
            segmentedViewController.delegate = self
        
            return segmentedViewController
        }
        
        return nil
    }
    
    //MARK:- Actions
    //MARK:-
    @IBAction func presentViewController() {
        
        let viewController = getSJSegmentedViewController()
        //        viewController
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

extension ViewController: SJSegmentedViewControllerDelegate {
    
    func didMoveToPage(controller: UIViewController, segment: SJSegmentTab?, index: Int) {
        
        if segmentedViewController.segments.count > 0 {
            
            
            
            let tab = segmentedViewController.segments[index] as? SJSegmentTab
    
            tab?.titleColor(UIColor.yellowColor())
                   
        }
        
    }
    
}