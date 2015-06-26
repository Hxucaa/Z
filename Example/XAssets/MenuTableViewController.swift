//
//  MenuTableViewController.swift
//  XAssets
//
//  Created by Lance Zhu on 2015-06-25.
//  Copyright (c) 2015 CocoaPods. All rights reserved.
//

import Foundation
import UIKit

final class MenuTableViewController : UITableViewController {
    
    /// A collection of items for table view. The name of item to be displayed and the segue identifier for navigating to the next controller.
    private let tableItems: [(name: String, segue: String)] = [
        ("Logo", "ToLogo")
    ]
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableItems.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell") as! UITableViewCell
        cell.textLabel?.text = tableItems[indexPath.row].name
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier(tableItems[indexPath.row].segue, sender: self)
    }
}