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
	var selectedSegment: UIButton?

	override func viewDidLoad() {
		super.viewDidLoad()

		adddChildViewController()
	}
    
    //MARK:- Private Function
    //MARK:-
    
    func getSJSegmentedViewController() -> SJSegmentedViewController? {
        
        if let storyboard = self.storyboard {
            
            let headerViewController = storyboard
                .instantiateViewController(withIdentifier: "HeaderViewController1")

            let firstViewController = storyboard
                .instantiateViewController(withIdentifier: "FirstTableViewController")

            let secondViewController = storyboard
                .instantiateViewController(withIdentifier: "SecondViewController")

            let thirdViewController = storyboard
                .instantiateViewController(withIdentifier: "ThirdViewController")

			let fourthViewController = storyboard
				.instantiateViewController(withIdentifier: "CollectionViewIdentifier")

            segmentedViewController.headerViewController = headerViewController
            segmentedViewController.segmentControllers = [firstViewController,
                                                          secondViewController,
                                                          thirdViewController,
                                                          fourthViewController]
            segmentedViewController.headerViewHeight = 200
			segmentedViewController.selectedSegmentViewHeight = 5.0
			segmentedViewController.segmentTitleColor = UIColor.gray
            segmentedViewController.segmentShadow = SJShadow.light()
            return segmentedViewController
        }
        
        return nil
    }
    
    func adddChildViewController() {
        
        let viewController = getSJSegmentedViewController()
        
        if viewController != nil {
            addChildViewController(viewController!)
            self.view.addSubview(viewController!.view)
            viewController!.view.frame = self.view.bounds
            viewController!.didMove(toParentViewController: self)
        }
    }
}
