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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.title = "Segment"
    }
    
    //MARK:- Private Function
    //MARK:-
    
    func getSJSegmentedViewController() -> SJSegmentedViewController? {
        
        if let storyboard = self.storyboard {
            
            let headerViewController = storyboard
                .instantiateViewController(withIdentifier: "HeaderViewController1")

            let firstViewController = storyboard
                .instantiateViewController(withIdentifier: "FirstTableViewController")
            firstViewController.title = "Table View"
            
            let secondViewController = storyboard
                .instantiateViewController(withIdentifier: "SecondViewController")
            secondViewController.title = "Custom View"
            
            let thirdViewController = storyboard
                .instantiateViewController(withIdentifier: "ThirdViewController")
            thirdViewController.title = "View"
            
            segmentedViewController.headerViewController = headerViewController
            segmentedViewController.segmentControllers = [firstViewController,
                                                          secondViewController,
                                                          thirdViewController]
            segmentedViewController.headerViewHeight = 200
            
            segmentedViewController.selectedSegmentViewColor = UIColor.red
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
            self.present(viewController!,
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
            viewController!.didMove(toParentViewController: self)
        }
    }
}

extension ViewController: SJSegmentedViewControllerDelegate {
    
    func didMoveToPage(_ controller: UIViewController, segment: UIButton?, index: Int) {
        
        if segmentedViewController.segments.count > 0 {
            
            let button = segmentedViewController.segments[index]
            button.setTitleColor(UIColor.red, for: .selected)
        }
    }
}
