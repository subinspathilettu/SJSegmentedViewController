//
//  ExamplePushViewController.swift
//  SJSegmentedScrollViewDemo
//
//  Created by Subins on 25/11/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit
import SJSegmentedScrollView

class ExamplePushViewController: UIViewController {

	@IBAction func push(_ sender: AnyObject) {

		if let storyboard = self.storyboard {

			let headerViewController = storyboard
				.instantiateViewController(withIdentifier: "HeaderViewController1")

			let firstViewController = storyboard
				.instantiateViewController(withIdentifier: "FirstTableViewController")
			firstViewController.title = "First"

			let secondViewController = storyboard
				.instantiateViewController(withIdentifier: "SecondViewController")
			secondViewController.title = "Second"

			let segmentController = SJSegmentedViewController()
			segmentController.headerViewController = headerViewController
			segmentController.segmentControllers = [firstViewController,
			                                        secondViewController]
			segmentController.headerViewHeight = 200.0
			navigationController?.pushViewController(segmentController, animated: true)
		}
	}
}
