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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellIdentifier", for: indexPath)
        
        cell.textLabel?.text = "Second View Row " + String((indexPath as NSIndexPath).row)
        
        return cell
    }
}

extension SecondViewController: SJSegmentedViewControllerViewSource {
    
    func viewForSegmentControllerToObserveContentOffsetChange(_ controller: UIViewController,
                                                              index: Int) -> UIView {
        return customTableView
    }
}
