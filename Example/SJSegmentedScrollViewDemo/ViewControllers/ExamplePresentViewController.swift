//
//  ExamplePresentViewController.swift
//  SJSegmentedScrollViewDemo
//
//  Created by Subins on 25/11/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit
import SJSegmentedScrollView

class ExamplePresentViewController: UIViewController {

	@IBAction func present(_ sender: AnyObject) {

		if let storyboard = self.storyboard {

			let headerViewController = storyboard
				.instantiateViewController(withIdentifier: "PresentHeader")

            let firstViewController = storyboard
                .instantiateViewController(withIdentifier: "PhotographersViewController")
            firstViewController.title = "Photographers"
            
            let secondViewController = storyboard
                .instantiateViewController(withIdentifier: "PhotosCollectionViewController")
            secondViewController.title = "Photos"
            let thirdViewController = storyboard.instantiateViewController(withIdentifier: "TestimonialTableViewController")
            thirdViewController.title = "Testimonial"

			let segmentController = SJSegmentedViewController()
			segmentController.headerViewController = headerViewController
			segmentController.segmentControllers = [thirdViewController,firstViewController,
			                                        secondViewController]
			segmentController.headerViewHeight = 200.0
            
            segmentController.segmentTitleColor = .darkGray
            segmentController.selectedSegmentViewColor = .black
            segmentController.segmentShadow = SJShadow.dark()

			present(segmentController, animated: true, completion: nil)
		}
	}
}
