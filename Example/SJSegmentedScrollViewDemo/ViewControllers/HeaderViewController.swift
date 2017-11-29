//
//  HeaderViewController.swift
//  SJSegmentedScrollView
//
//  Created by Subins Jose on 13/06/16.
//  Copyright © 2016 Subins Jose. All rights reserved.
//

import UIKit

class HeaderViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func headerViewAction(_ sender: AnyObject) {

		if navigationController?.isNavigationBarHidden == false {
			let viewController = self.storyboard?
				.instantiateViewController(withIdentifier: "HeaderDetailViewController")
			self.parent?.navigationController?.pushViewController(viewController!,
			                                                      animated: true)
		}
    }
}
