//
//  ExamplePushViewController.swift
//  SJSegmentedScrollViewDemo
//
//  Created by Subins on 24/11/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit
import SJSegmentedScrollView

class ExamplePushViewController: UIViewController {

	override func viewDidLoad() {
		super.viewDidLoad()

		// Do any additional setup after loading the view.
	}

	@IBAction func present(_ sender: AnyObject) {

		if let storyboard = self.storyboard {
			let firstViewController = storyboard
				.instantiateViewController(withIdentifier: "FirstTableViewController")
			firstViewController.title = "First"

			let secondViewController = storyboard
				.instantiateViewController(withIdentifier: "SecondViewController")
			secondViewController.title = "Second"

			let segmentController = SJSegmentedViewController()
			segmentController.headerViewController = nil
			segmentController.segmentControllers = [firstViewController,
			                                        secondViewController]
			present(segmentController, animated: true, completion: nil)
		}
	}
}
