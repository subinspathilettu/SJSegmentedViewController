//
//  SecondViewController.swift
//  SJSegmentedScrollView
//
//  Created by Subins Jose on 13/06/16.
//  Copyright © 2016 Subins Jose. All rights reserved.
//

import UIKit
import SJSegmentedScrollView

class SecondViewController: UIViewController {
    
    @IBOutlet weak var customTableView: UITableView!
}

extension SecondViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 20
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CellIdentifier", forIndexPath: indexPath)
        
        cell.textLabel?.text = "Second View Row " + String(indexPath.row)
        
        return cell
    }
}

extension SecondViewController: SJSegmentedViewControllerViewSource {
    
    func viewForSegmentControllerToObserveContentOffsetChange(controller: UIViewController,
                                                              index: Int) -> UIView {
        return customTableView
    }
}
