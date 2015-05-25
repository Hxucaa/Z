//
//  ViewController.swift
//  XListing
//
//  Created by Lance on 2015-03-17.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import UIKit
import ReactKit
import Haneke

private let NumberOfRowsPerSection = 1
private let CellIdentifier = "Cell"
private let SegueIdentifier = "FromFeaturedToNearby"

public class FeaturedListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var nearbyButton: UIBarButtonItem!
    @IBOutlet weak var profileButton: UIBarButtonItem!
    public var refreshControl: UIRefreshControl!
    
    /// ViewModel
    public var featuredListVM: IFeaturedListViewModel?
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        let signUpVC = SignInViewController(nibName: "SignInViewController", bundle: nil)
        
        featuredListVM!.getBusiness()
        
        self.presentViewController(signUpVC, animated: true, completion: nil)
        
        // Setup delegates
        tableView.delegate = self
        tableView.dataSource = self
        
        // Setup table
        setupTable()
        
        // Set up pull to refresh
        setUpRefresh()
        
        // Setup nearbyButton
        setupNearbyButton()
        // Setup profileButton
        setupProfileButton()
        
        
        
    }

    public override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func setUpRefresh() {
        var refreshControl = UIRefreshControl()
        self.tableView.addSubview(refreshControl)
        refreshControl.addTarget(self, action: "reorderTable", forControlEvents:UIControlEvents.ValueChanged)
        refreshControl.attributedTitle = NSAttributedString(string: "Reordering Listings")

        self.refreshControl = refreshControl
        
    }
    
    public func reorderTable (){
        shuffle(featuredListVM!.businessDynamicArr.proxy)
        self.tableView.reloadData()
        self.refreshControl.endRefreshing()
    }
    
    private func shuffle(array: NSMutableArray){
        let c = array.count
        
        if (c > 0){
            for i in 0..<(c - 1) {
                let j = Int(arc4random_uniform(UInt32(c - i))) + i
                swap(&array[i], &array[j])
            }
        }
        return
    }
    /**
    React to signal coming from view model and update table accordingly.
    */
    private func setupTable() {
        // Setup signal
        let businessVMArrSignal = featuredListVM!.businessDynamicArr.stream().ownedBy(self)
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
        let nearbyButtonSignal = nearbyButton.stream().ownedBy(self)
        nearbyButtonSignal ~> { [unowned self] button -> Void in
            featuredListVM?.pushNearbyModule()
        }
    }

    /**
    React to Profile Button and present ProfileViewController.
    */
    private func setupProfileButton() {
        let profileButtonSignal = profileButton.stream().ownedBy(self)
        profileButtonSignal ~> { [unowned self] button -> Void in
            featuredListVM?.pushProfileModule()
        }
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
        return featuredListVM!.businessDynamicArr.proxy.count
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
        
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        cell.layoutMargins = UIEdgeInsetsZero;
        cell.preservesSuperviewLayoutMargins = false;
        
        let section = indexPath.section
        
        var businessNameLabel : UILabel? = cell.viewWithTag(1) as? UILabel
        var wantToGoLabel: UILabel? = cell.viewWithTag(2) as? UILabel
        var cityLabel : UILabel? = cell.viewWithTag(4) as? UILabel
        var openingLabel: UILabel? = cell.viewWithTag(6) as? UILabel
        var coverImageView = cell.viewWithTag(3) as? UIImageView
        
        let arr = featuredListVM!.businessDynamicArr.proxy
        if (arr.count > section){
//            let businessVM = arr[section] as! FeaturedListCellViewModel
            let businessVM = arr[section] as! FeaturedListCellViewModel
            
            businessNameLabel?.text = businessVM.businessName
            
            wantToGoLabel?.text = businessVM.wantToGoText
            
            //TODO:
            //city and distance data not set up yet, temporarilily hard coded
            cityLabel?.text = businessVM.city + " • 开车15分钟"
            
            
            openingLabel?.text = businessVM.openingText
            
            if let url = businessVM.coverImageNSURL {
                coverImageView!.hnk_setImageFromURL(url, failure: {
                    println("Image loading failed: \($0)")
                })
            }
            
            //TO DO:
            //temp restaurant image; remove once cover image is linked properly
            coverImageView?.image = UIImage (named: "tempRestImage")
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
 
        // pass business info to detail view and push it
        featuredListVM?.pushDetailModule(indexPath.section)
    }
}