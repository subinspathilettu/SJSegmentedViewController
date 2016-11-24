//
//  ViewController.swift
//  SJSegmentedScrollView
//
//  Created by Subins Jose on 06/10/2016.
//  Copyright © 2016 Subins Jose. All rights reserved.
//

import UIKit
import SJSegmentedScrollView

class ViewController: SJSegmentedViewController {

	override func viewDidLoad() {
		if let storyboard = self.storyboard {

			let headerController = storyboard
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

			headerViewController = headerController
			segmentControllers = [firstViewController,
			                           secondViewController,
			                           thirdViewController,
			                           fourthViewController]
			headerViewHeight = 200
			selectedSegmentViewHeight = 5.0
			segmentTitleColor = UIColor.gray
			segmentShadow = SJShadow.light()
		}

		title = "Segment"
		super.viewDidLoad()
	}

	func getSegmentTabWithImage(_ imageName: String) -> UIView {

		let view = UIImageView()
		view.frame.size.width = 100
		view.image = UIImage(named: imageName)
		view.contentMode = .scaleAspectFit
		view.backgroundColor = .white
		return view
	}
}
