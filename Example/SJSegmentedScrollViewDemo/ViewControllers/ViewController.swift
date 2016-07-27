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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let storyboard = self.storyboard {
            
            let headerViewController = storyboard
                .instantiateViewController(withIdentifier: "HeaderViewController")
            
            let firstViewController = storyboard
                .instantiateViewController(withIdentifier: "FirstTableViewController")
            firstViewController.title = "Table View"
            
            let secondViewController = storyboard
                .instantiateViewController(withIdentifier: "SecondViewController")
            secondViewController.title = "Custom View"
            
            let thirdViewController = storyboard
                .instantiateViewController(withIdentifier: "ThirdViewController")
            thirdViewController.title = "View"
            
            let segmentedViewController = SJSegmentedViewController(headerViewController: headerViewController,
                                                                    segmentControllers: [firstViewController,
                                                                        secondViewController,
                                                                        thirdViewController])
            segmentedViewController.selectedSegmentViewColor = UIColor.red()
            self.present(segmentedViewController, animated: false, completion: nil)
        }
    }
}
