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
        //self.navigationController?.title = "Wedding Clicks"
        title = "SJSegmentVC"
        self.navigationItem.title = "WEDDING CLICKS"
        //self.navigationController?.navigationBar.topItem?.title = "zurück"
        
		if let storyboard = self.storyboard {

			let headerController = storyboard
				.instantiateViewController(withIdentifier: "HeaderViewController1")

			let firstViewController = storyboard
				.instantiateViewController(withIdentifier: "PhotographersViewController")
			firstViewController.title = "Photographers"

			let secondViewController = storyboard
				.instantiateViewController(withIdentifier: "PhotosCollectionViewController")
			secondViewController.title = "Photos"
            let thirdViewController = storyboard.instantiateViewController(withIdentifier: "TestimonialTableViewController")
            thirdViewController.title = "Testimonial"

//			let thirdViewController = storyboard
//				.instantiateViewController(withIdentifier: "ThirdViewController") as? ThirdViewController
//			thirdViewController?.title = "Third"
//			thirdViewController?.loadViewController = { (index) in
//				self.setSelectedSegmentAt(index, animated: true)
//			}
//
//			let fourthViewController = storyboard
//				.instantiateViewController(withIdentifier: "TestimonialViewController")
//			fourthViewController.title = "Fourth"

			headerViewController = headerController
			segmentControllers = [secondViewController,firstViewController,
			                           thirdViewController,
			                          ]
            segmentBounces = true
			headerViewHeight = 200
			selectedSegmentViewHeight = 5.0
			segmentTitleColor = .lightGray
			selectedSegmentViewColor = .black
			segmentShadow = SJShadow.dark()
			delegate = self
		}

	//	title = "Segment"
		super.viewDidLoad()
        //self.edgesForExtendedLayout = []
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
			selectedSegment?.titleColor(.darkGray)
		}
	}
}

