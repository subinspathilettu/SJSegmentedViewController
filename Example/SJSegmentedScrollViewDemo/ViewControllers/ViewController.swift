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

	var selectedSegment: SJSegmentTab?

	override func viewDidLoad() {
		if let storyboard = self.storyboard {

			let headerController = storyboard
				.instantiateViewController(withIdentifier: "HeaderViewController1")

			let firstViewController = storyboard
				.instantiateViewController(withIdentifier: "FirstTableViewController")
			firstViewController.title = "First"

			let secondViewController = storyboard
				.instantiateViewController(withIdentifier: "SecondViewController")
			secondViewController.title = "Second"

			let thirdViewController = storyboard
				.instantiateViewController(withIdentifier: "ThirdViewController") as? ThirdViewController
			thirdViewController?.title = "Third"
			thirdViewController?.loadViewController = { (index) in
				self.setSelectedSegmentAt(index, animated: true)
			}

			let fourthViewController = storyboard
				.instantiateViewController(withIdentifier: "CollectionViewIdentifier")
			fourthViewController.title = "Fourth"

			headerViewController = headerController
			segmentControllers = [firstViewController,
			                           secondViewController,
			                           thirdViewController!,
			                           fourthViewController]
			headerViewHeight = 200
			selectedSegmentViewHeight = 5.0
			headerViewOffsetHeight = 31.0
			segmentTitleColor = .gray
			selectedSegmentViewColor = .red
			segmentShadow = SJShadow.light()
			showsHorizontalScrollIndicator = false
			showsVerticalScrollIndicator = false
			delegate = self
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

extension ViewController: SJSegmentedViewControllerDelegate {

	func didMoveToPage(_ controller: UIViewController, segment: SJSegmentTab?, index: Int) {

		if selectedSegment != nil {
			selectedSegment?.titleColor(.lightGray)
		}

		if segments.count > 0 {

			selectedSegment = segments[index]
			selectedSegment?.titleColor(.red)
		}
	}
}

