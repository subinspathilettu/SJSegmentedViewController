//
//  ThirdViewController.swift
//  SJSegmentedScrollView
//
//  Created by Subins on 13/07/16.
//  Copyright © 2016 Subins Jose. All rights reserved.
//

import UIKit
import SJSegmentedScrollView

class ThirdViewController: UIViewController {

	var loadViewController: ((_ index: Int) -> Void)?

	@IBAction func loadSegment(_ sender: Any) {

		if loadViewController != nil {
			loadViewController!(0)
		}
	}
}
