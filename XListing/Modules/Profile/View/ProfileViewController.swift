//
// Created by Lance on 15-05-06.
// Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import UIKit

public class ProfileViewController : UIViewController {

    public var profileVM: IProfileViewModel?

    @IBOutlet weak var tableView: UITableView!
    public var firstSegSelected = true
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        println("I'm in ProfileViewController")
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.navigationItem.title = "我的"
    }

    public override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


/**
*  UITableViewDataSource
*/
extension ProfileViewController : UITableViewDataSource {
    /**
    Asks the data source to return the number of sections in the table view.
    
    :param: tableView An object representing the table view requesting this information.
    
    :returns: The number of sections in tableView. The default value is 1.
    */
    public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    /**
    Tells the data source to return the number of rows in a given section of a table view. (required)
    
    :param: tableView The table-view object requesting this information.
    :param: section   An index number identifying a section in tableView.
    
    :returns: The number of rows in section.
    */
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 8
        
    }
    
    /**
    Asks the data source for a cell to insert in a particular location of the table view. (required)
    
    :param: tableView A table-view object requesting the cell.
    :param: indexPath An index path locating a row in tableView.
    
    :returns: An object inheriting from UITableViewCell that the table view can use for the specified row. An assertion is raised if you return nil
    */
    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        switch (indexPath.row){
        case 0:
            var profileCell = tableView.dequeueReusableCellWithIdentifier("ProfileCell", forIndexPath: indexPath) as! UITableViewCell
            
            var profilePicImageView = profileCell.viewWithTag(1) as? UIImageView
            var nameLabel : UILabel? = profileCell.viewWithTag(2) as? UILabel
            nameLabel!.text = UserService.getDisplayName()
            var horoscopeAgeLabel: UILabel? = profileCell.viewWithTag(3) as? UILabel
            var cityLabel : UILabel? = profileCell.viewWithTag(4) as? UILabel
            

            
            return profileCell
        case 1:
            var segmentedCell = tableView.dequeueReusableCellWithIdentifier("SegmentedCell", forIndexPath: indexPath) as! UITableViewCell
            var segmentedControl = segmentedCell.viewWithTag(1) as? UISegmentedControl
            
            segmentedControl?.addTarget(self, action: "switchSegment", forControlEvents: UIControlEvents.ValueChanged)
            
 
  
            return segmentedCell
        default:
            
            if (self.firstSegSelected) {
                
                if (indexPath.row%2 == 0){
                    
                    var chatCell = tableView.dequeueReusableCellWithIdentifier("ChatCell", forIndexPath: indexPath) as! UITableViewCell
                    
                    var chatImage = chatCell.viewWithTag(1) as? UIImageView
                    var chatMessage = chatCell.viewWithTag(2) as? UILabel
                    var cityName = chatCell.viewWithTag(3) as? UILabel
                    var timestamp = chatCell.viewWithTag(4) as? UILabel
                    
                    
                    return chatCell
                }else{
                
                
                    var notificationCell = tableView.dequeueReusableCellWithIdentifier("NotificationCell", forIndexPath: indexPath) as! UITableViewCell
                    var notificationMessage = notificationCell.viewWithTag(1) as? UILabel
                    var img1 = notificationCell.viewWithTag(2) as? UIImageView
                    var img2 = notificationCell.viewWithTag(3) as? UIImageView
                    var img3 = notificationCell.viewWithTag(4) as? UIImageView
                    var img4 = notificationCell.viewWithTag(5) as? UIImageView
                    var img5 = notificationCell.viewWithTag(6) as? UIImageView
                    var timestamp = notificationCell.viewWithTag(7) as? UIImageView
                    
                    return notificationCell
                }
            }else{
            
            
            var businessCell = tableView.dequeueReusableCellWithIdentifier("BusinessCell", forIndexPath: indexPath) as! UITableViewCell
            var businessImageView = businessCell.viewWithTag(1) as? UIImageView
            var businessName = businessCell.viewWithTag(2) as? UILabel
            var cityName = businessCell.viewWithTag(3) as? UILabel
            var icon = businessCell.viewWithTag(4) as? UIButton
            
            
            return businessCell
            }

        }
        
        
        
        
    }
    
    public func switchSegment(){
        if (self.firstSegSelected){
            self.firstSegSelected = false
        }else{
            self.firstSegSelected = true
        }
        self.tableView.reloadData()
    }
    
    
    
    public func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch (indexPath.row){
            case 0: return 87
            case 1: return 43
            default: return 66
        }

    }
    
    public func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return ""
    }
    
    public func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 2
    }
    
    public func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 2
    }
}

/**
*  UITableViewDelegate
*/
extension ProfileViewController : UITableViewDelegate {
    /**
    Tells the delegate that the specified row is now selected.
    
    :param: tableView A table-view object informing the delegate about the new row selection.
    :param: indexPath An index path locating the new selected row in tableView.
    */
    public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //tableView.deselectRowAtIndexPath(indexPath, animated: true)
        

        
        
    }
}
