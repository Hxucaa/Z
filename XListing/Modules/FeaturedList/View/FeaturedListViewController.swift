//
//  ViewController.swift
//  XListing
//
//  Created by Lance on 2015-03-17.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import UIKit
import ReactKit
import Realm
import Haneke

private let NumberOfRowsPerSection = 1
private let CellIdentifier = "Cell"
private let SegueIdentifier = "FromFeaturedToNearby"

public class FeaturedListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var nearbyButton: UIBarButtonItem!
    
    public weak var navigationDelegate: FeaturedListViewControllerNavigationDelegate?
    
    /// ViewModel
    public var featuredListVM: IFeaturedListViewModel?
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup delegates
        tableView.delegate = self
        tableView.dataSource = self
        
        // Setup table
        setupTable()
        
        // Setup nearbyButton
        setupNearbyButton()
        
        featuredListVM!.getBusiness()
    }

    public override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /**
    React to signal coming from view model and update table accordingly.
    */
    private func setupTable() {
        // Setup signal
        let businessVMArrSignal = featuredListVM!.businessVMArr.signal().ownedBy(self)
        businessVMArrSignal ~> { [unowned self] changedValues, change, indexSet in
            /**
            *  Programatically insert each business view model to the table
            */
            if change == .Insertion {
                self.tableView.beginUpdates()
                self.tableView.insertSections(indexSet, withRowAnimation: UITableViewRowAnimation.Automatic)
                self.tableView.endUpdates()
            }
        }
    }
    
    /**
    React to Nearby Button and present NearbyViewController.
    */
    private func setupNearbyButton() {
        let nearbyButtonSignal = nearbyButton.signal { [unowned self] button -> Void in
//            self.pushNearbyViewController!()
            self.navigationDelegate?.pushNearby()
        }
        nearbyButtonSignal.ownedBy(self)
        nearbyButtonSignal ~> {}
    }
}

/**
*  UITableViewDataSource
*/
extension FeaturedListViewController : UITableViewDataSource {
    /**
    Asks the data source to return the number of sections in the table view.
    
    :param: tableView An object representing the table view requesting this information.
    
    :returns: The number of sections in tableView. The default value is 1.
    */
    public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return featuredListVM!.businessVMArr.proxy.count
    }
    
    /**
    Tells the data source to return the number of rows in a given section of a table view. (required)
    
    :param: tableView The table-view object requesting this information.
    :param: section   An index number identifying a section in tableView.
    
    :returns: The number of rows in section.
    */
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return NumberOfRowsPerSection
    }
    
    /**
    Asks the data source for a cell to insert in a particular location of the table view. (required)
    
    :param: tableView A table-view object requesting the cell.
    :param: indexPath An index path locating a row in tableView.
    
    :returns: An object inheriting from UITableViewCell that the table view can use for the specified row. An assertion is raised if you return nil
    */
    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(CellIdentifier, forIndexPath: indexPath) as! UITableViewCell
        
        let section = indexPath.section
        
        var businessNameLabel : UILabel? = self.view.viewWithTag(1) as? UILabel
        var wantToGoLabel: UILabel? = self.view.viewWithTag(2) as? UILabel
        var cityLabel : UILabel? = self.view.viewWithTag(4) as? UILabel
        var oldPriceLabel : UILabel? = self.view.viewWithTag(5) as? UILabel
        let coverImageView = self.view.viewWithTag(3) as? UIImageView
        
        let arr = featuredListVM!.businessVMArr.proxy
        if (arr.count > section){
            let businessVM = arr[section] as! BusinessViewModel
            
            
            let englishName = businessVM.nameEnglish
            let chineseName = businessVM.nameSChinese
            let wantToGoCounter = businessVM.wantToGoCounter
            
            let oldPrice: NSMutableAttributedString =  NSMutableAttributedString(string: "$80")
            oldPrice.addAttribute(NSStrikethroughStyleAttributeName, value: 2, range: NSMakeRange(0, oldPrice.length))
            
            businessNameLabel?.text = chineseName!// + " | " + englishName!
            if (wantToGoCounter > 0) {
                wantToGoLabel?.text = String(format: "%d+ 人想去", wantToGoCounter)
            }
            else {
                wantToGoLabel?.hidden = true
            }
            //distanceLabel?.text = businessVM.distance
            //coverImageView?.image = businessVM.coverImage!
            cityLabel?.text = businessVM.city
            oldPriceLabel?.attributedText = oldPrice

            coverImageView!.hnk_setImageFromURL(NSURL(string: businessVM.coverImageUrl!)!, failure: {
                println("Image loading failed: \($0)")
            })

        }
        
        return cell
    }
}

/**
*  UITableViewDelegate
*/
extension FeaturedListViewController : UITableViewDelegate {
    /**
    Tells the delegate that the specified row is now selected.
    
    :param: tableView A table-view object informing the delegate about the new row selection.
    :param: indexPath An index path locating the new selected row in tableView.
    */
    public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let businessVM = featuredListVM!.businessVMArr.proxy[indexPath.section] as! BusinessViewModel
        // pass business info to detail view and push it
        navigationDelegate?.pushDetail(businessVM)
    }
}