//
//  WantToGoTableViewController.swift
//  XListing
//
//  Created by Bruce Li on 2015-05-29.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import UIKit
import ReactiveCocoa

public final class WantToGoTableViewController: UITableViewController {
        
    @IBOutlet weak var genderSegmentedControl: UISegmentedControl!
    
    var selectedPplArrayM : NSMutableArray = []
    var selectedPplArrayW : NSMutableArray = []
    
    public override func viewDidLoad() {
        super.viewDidLoad()

        self.loadTestArray()
        genderSegmentedControl?.addTarget(self, action: "switchSegment", forControlEvents: UIControlEvents.ValueChanged)
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    func loadTestArray(){
        for i in 0 ... 7{
            selectedPplArrayM.addObject(false)
            selectedPplArrayW.addObject(false)
        }
    }
    
    func switchSegment(){
        self.tableView.reloadData()
    }

    public override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    public override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    public override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return 8
    }
    
    func convertImgToCircle(imageView: UIImageView){
        let imgWidth = CGFloat(imageView.frame.width)
        imageView.layer.cornerRadius = imgWidth / 2
        imageView.layer.masksToBounds = true;
        return
    }

    
    public override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("wantToGoCell", forIndexPath: indexPath) as! UITableViewCell
        
        var profilePicImageView = cell.viewWithTag(1) as? UIImageView
        var nameLabel : UILabel? = cell.viewWithTag(2) as? UILabel
        var horoscopeAgeLabel: UILabel? = cell.viewWithTag(3) as? UILabel
        var cityLabel : UILabel? = cell.viewWithTag(4) as? UILabel
        var wantToGoButton : UIButton? = cell.viewWithTag(5) as? UIButton
        
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        wantToGoButton?.addTarget(self, action: "tappedButton:", forControlEvents: UIControlEvents.TouchUpInside)
        
        var buttonState = false
        
        if (genderSegmentedControl.selectedSegmentIndex == 0){
            profilePicImageView?.image = UIImage( named: "curry")
            buttonState = selectedPplArrayM.objectAtIndex(indexPath.row) as! Bool
        }else{
            profilePicImageView?.image = UIImage( named: "lebron")
            buttonState = selectedPplArrayW.objectAtIndex(indexPath.row) as! Bool
        }
 
        
        if (buttonState){
            wantToGoButton?.setTitle("\u{f004} 一起去", forState: UIControlState.Normal)
        }else{
            wantToGoButton?.setTitle("\u{f08a} 一起去", forState: UIControlState.Normal)
        }
        
        
        
        self.convertImgToCircle(profilePicImageView!);

        return cell
    }
    
    func tappedButton(sender: UIButton) {
        let tappedCell = sender.superview?.superview as! UITableViewCell
        var indexPath = self.tableView.indexPathForCell(tappedCell)
        
        var buttonState = false
        
        if (genderSegmentedControl.selectedSegmentIndex == 0){
        
         buttonState = selectedPplArrayM.objectAtIndex(indexPath!.row) as! Bool
         self.selectedPplArrayM[indexPath!.row] = !buttonState
        }else{
          buttonState = selectedPplArrayW.objectAtIndex(indexPath!.row) as! Bool
        self.selectedPplArrayW[indexPath!.row] = !buttonState

        }
        
        self.tableView.reloadData()
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */
    
}
