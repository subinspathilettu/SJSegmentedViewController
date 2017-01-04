//
//  TestimonialTableViewController.swift
//  SJSegmentedScrollViewDemo
//
//  Created by Sonnet on 27/12/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit

class TestimonialTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        refreshControl?.addTarget(self,
                                  action: #selector(TestimonialTableViewController.handleRefresh(refreshControl:)),
                                  for: UIControlEvents.valueChanged)
    }

    
    func handleRefresh(refreshControl: UIRefreshControl) {
        
        self.perform(#selector(self.endRefresh), with: nil, afterDelay: 1.0)
        
    }
    
    func endRefresh() {
        
        refreshControl?.endRefreshing()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 4
    }

    
}
