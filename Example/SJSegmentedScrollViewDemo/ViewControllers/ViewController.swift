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
			firstViewController.navigationItem.titleView = getSegmentTabWithImage("Fire Hydrant-50")

            let secondViewController = storyboard
                .instantiateViewController(withIdentifier: "SecondViewController")
			secondViewController.navigationItem.titleView = getSegmentTabWithImage("Fountain-50")

            let thirdViewController = storyboard
                .instantiateViewController(withIdentifier: "ThirdViewController")
			thirdViewController.navigationItem.titleView = getSegmentTabWithImage("Handcuffs-50")

			let fourthViewController = storyboard
				.instantiateViewController(withIdentifier: "CollectionViewIdentifier")
			fourthViewController.navigationItem.titleView = getSegmentTabWithImage("Heart Balloon-50")

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

	func getSegmentTabWithImage(_ imageName: String) -> UIView {

		let view = UIImageView()
		view.frame.size.width = 100
		view.image = UIImage(named: imageName)
		view.contentMode = .scaleAspectFit
		view.backgroundColor = .white
		return view
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
