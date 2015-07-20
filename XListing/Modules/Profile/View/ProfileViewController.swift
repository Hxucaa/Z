//
// Created by Lance on 15-05-06.
// Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import UIKit
import ReactiveCocoa

private let NumRowsBeforeData = 2

public final class ProfileViewController : XUIViewController {

    private var profileVM: IProfileViewModel!

    @IBOutlet weak var tableView: UITableView!
    public var firstSegSelected = true
    public var selectedBusinessChoiceIndex = 0
    
    public var numberOfChats = 8;
    public var businessChoiceArr : NSMutableArray = []
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.initializeBusinessArr()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.navigationItem.title = "个人"
    }
    
    public func initializeBusinessArr () {
        for i in 0...1 {
            self.businessChoiceArr.addObject(1)
        }
        for i in 1...2 {
            self.businessChoiceArr.addObject(2)
        }
        for i in 3...4 {
            self.businessChoiceArr.addObject(3)
        }
    
    }

    public override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    public func bindToViewModel(profileViewModel: IProfileViewModel) {
        profileVM = profileViewModel
    }
    

    public override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        if (segue.identifier == "presentProfileEdit") {
            let profileEditVC = segue.destinationViewController.topViewController as! ProfileEditViewController
            profileEditVC.bindToViewModel(profileVM.profileEditViewModel)
        }
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
        
        return numberOfChats
        
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
//            nameLabel!.text = UserService.getDisplayName()
            var horoscopeAgeLabel: UILabel? = profileCell.viewWithTag(3) as? UILabel
            var cityLabel : UILabel? = profileCell.viewWithTag(4) as? UILabel
            
            self.convertImgToCircle(profilePicImageView!)

            nameLabel!.rac_text <~ profileVM.nickname
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
                    
                    self.convertImgToCircle(chatImage!)
                    
                    
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
                    
                    self.convertImgToCircle(img1!)
                    self.convertImgToCircle(img2!)
                    self.convertImgToCircle(img3!)
                    self.convertImgToCircle(img4!)
                    self.convertImgToCircle(img5!)
                    
                    return notificationCell
                }
            }else{
            
            
            var businessCell = tableView.dequeueReusableCellWithIdentifier("BusinessCell", forIndexPath: indexPath) as! UITableViewCell
            var businessImageView = businessCell.viewWithTag(1) as? UIImageView
            var businessName = businessCell.viewWithTag(2) as? UILabel
            var cityName = businessCell.viewWithTag(3) as? UILabel
            var iconButton = businessCell.viewWithTag(4) as? UIButton
                
            let iconWidth = CGFloat(iconButton!.frame.width)
            iconButton!.layer.cornerRadius = iconWidth / 2
            iconButton!.layer.masksToBounds = true;
            
            iconButton!.addTarget(self, action: "changeParticipation:", forControlEvents: UIControlEvents.TouchUpInside)
                
                var choiceInt : Int = self.businessChoiceArr.objectAtIndex(indexPath.row - NumRowsBeforeData) as! Int
                switch (choiceInt){
                case 1:
                    iconButton?.setTitle("去", forState: UIControlState.Normal)
                    iconButton?.backgroundColor = UIColor(red: 171/255.0, green: 232/255.0, blue: 116/255.0, alpha: 1)
                case 2:
                    iconButton?.setTitle("请", forState: UIControlState.Normal)
                    iconButton?.backgroundColor = UIColor(red: 65/255.0, green: 166/255.0, blue: 157/255.0, alpha: 1)
                default:
                    iconButton?.setTitle("A", forState: UIControlState.Normal)
                    iconButton?.backgroundColor = UIColor(red: 241/255.0, green: 150/255.0, blue: 38/255.0, alpha: 1)
                }
                
            
            return businessCell
            }

        }
        
        
        
        
    }
    
    public func changeParticipation (sender:UIButton) {
        
        //get the index path for the selected button
        var buttonFrame = sender.convertRect(sender.bounds, toView: self.tableView)
        var indexPath = self.tableView.indexPathForRowAtPoint(buttonFrame.origin)
        self.selectedBusinessChoiceIndex = indexPath!.row - NumRowsBeforeData
        self.presentPopover()
    }
    
    public func presentPopover () {
        //create the popover and present it
        var popover = ParticipationPopover()
        popover.delegate = self
        var alert: (UIAlertController) = popover.createPopover()
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    public func convertImgToCircle(imageView: UIImageView){
        let imgWidth = CGFloat(imageView.frame.width)
        imageView.layer.cornerRadius = imgWidth / 2
        imageView.layer.masksToBounds = true;
        return
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
            case 0: return 88
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

extension ProfileViewController : ParticipationPopoverDelegate {
    //switch the participation icon based on the selection from the popover
    public func alertAction(choiceTag: Int) {
        self.businessChoiceArr[self.selectedBusinessChoiceIndex] = choiceTag
        self.tableView.reloadData()
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
    
    public func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        
        if (indexPath.row > 1){
            return true;
        }else{
            return false;
        }
    }
    
    public func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if (editingStyle == UITableViewCellEditingStyle.Delete){
            
            numberOfChats--
            [self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)]
        }
        
    }
    
    public override func setEditing(editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        if (editing){
            ProfileLogDebug("EDITING")
            self.tableView.setEditing(true, animated: true)
        }else{
            ProfileLogDebug("DONE")
            self.tableView.setEditing(false, animated: false)
        }
    
    }
}