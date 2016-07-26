//
//  FirstTableViewController.swift
//  SJSegmentedScrollView
//
//  Created by Subins Jose on 13/06/16.
//  Copyright © 2016 Subins Jose. All rights reserved.
//

import UIKit

class FirstTableViewController: UITableViewController {

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 25
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellIdentifier", for: indexPath)

        cell.textLabel?.text = "Row " + String((indexPath as NSIndexPath).row)

        return cell
    }
    
    func viewForObserve() -> UIView{
        
        return self.tableView
    }
}
