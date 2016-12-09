//
//  SecondSJViewController.swift
//  SJSegmentedScrollViewDemo
//
//  Created by Subins on 23/11/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit
import SJSegmentedScrollView

class SecondSJViewController: UIViewController {

	let segmentedViewController = SJSegmentedViewController()
	var selectedSegment: UIButton?

	override func viewDidLoad() {
		super.viewDidLoad()

		addChildViewController()
	}

	//MARK:- Private Function
	

	func getSJSegmentedViewController() -> SJSegmentedViewController? {

		if let storyboard = self.storyboard {

			let headerViewController = storyboard
				.instantiateViewController(withIdentifier: "HeaderViewController1")

			let firstViewController = storyboard
				.instantiateViewController(withIdentifier: "FirstTableViewController")
			firstViewController.title = "First"

			let secondViewController = storyboard
				.instantiateViewController(withIdentifier: "SecondViewController")

			segmentedViewController.headerViewController = headerViewController
			segmentedViewController.segmentControllers = [firstViewController,
			                                              secondViewController]
			segmentedViewController.headerViewHeight = 100
			return segmentedViewController
		}

		return nil
	}

	func addChildViewController() {

		let viewController = getSJSegmentedViewController()

		if viewController != nil {
			addChildViewController(viewController!)
			self.view.addSubview(viewController!.view)
			viewController!.view.frame = self.view.bounds
			viewController!.didMove(toParentViewController: self)
		}
	}
}
