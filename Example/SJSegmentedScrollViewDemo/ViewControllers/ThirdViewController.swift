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
}

extension ThirdViewController: SJSegmentedViewControllerViewSource {

	public func titleForSegment() -> String? {

		return "Third"
	}
}
