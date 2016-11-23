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

			segmentedViewController.headerViewController = headerViewController
			segmentedViewController.segmentControllers = [firstViewController,
			                                              secondViewController]
			segmentedViewController.headerViewHeight = 100
			return segmentedViewController
		}

		return nil
	}

	func getSegmentTabWithImage(_ imageName: String) -> UIView {

		let view = UIImageView()
		view.frame.size.width = 50
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
