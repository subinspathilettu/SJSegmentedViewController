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
      
        title = "SJSegmentVC"
        self.navigationItem.title = "WEDDING CLICKS"
              
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
			selectedSegment?.titleColor(.darkGray)
		}
	}
}

