//
//  DetailViewController.swift
//  XListing
//
//  Created by Lance Zhu on 2015-04-15.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import UIKit
import ReactKit
import MapKit
import WebKit

private let CityDistanceSeparator = " • "

public class DetailViewController : UIViewController, MKMapViewDelegate {
    
    public var detailVM: IDetailViewModel!
    
    public var mapView = MKMapView()
    
    public var expandHours: Bool = false
    public var isGoing: Bool = false
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var profileButton: UIBarButtonItem!
    
    internal var businessNameStream: Stream<AnyObject?>!
    internal var cityAndDistanceStream: Stream<AnyObject?>!
    internal var wantToGoButtonStream: Stream<String>!
    internal var shareButtonStream: Stream<String>!
    internal var coverImageNSURLStream: Stream<AnyObject?>!

    public override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        self.navigationItem.title = detailVM.detailBusinessInfoVM.navigationTitle
    }
    
    public override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    public override func viewDidDisappear(animated: Bool) {
        super.viewDidAppear(animated)
        
        /**
        Set streams to nil.
        */
        businessNameStream = nil
        cityAndDistanceStream = nil
        wantToGoButtonStream = nil
        shareButtonStream = nil
    
    }
    
    @IBAction func shareButtonTapped(sender: AnyObject) {
        self.shareSheetAction()
    }

    /**
    React to Profile Button and present ProfileViewController.
    */
    private func setupProfileButton() {
        let profileButtonSignal = profileButton.stream().ownedBy(self)
        profileButtonSignal ~> { [unowned self] button -> Void in
            detailVM?.pushProfileModule()
        }
        
    }
    
    public func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        if (annotation is MKUserLocation) {
            //if annotation is not an MKPointAnnotation (eg. MKUserLocation),
            //return nil so map draws default view for it (eg. blue dot)...
            return nil
        }
        
        let reuseId = "test"
        
        var anView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId)
        if anView == nil {
            anView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            anView.image = UIImage(named:"mapPin")
            anView.canShowCallout = true
        }
        else {
            //we are re-using a view, update its annotation reference...
            anView.annotation = annotation
        }
        
        return anView
    }
    
    public func wantToGoPopover(){
        var alert = UIAlertController(title: "请选一种", message: "", preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(title: "我想去", style: UIAlertActionStyle.Default) { alert in
            self.alertAction()
            })
        alert.addAction(UIAlertAction(title: "我想请客", style: UIAlertActionStyle.Default) { alert in
            self.alertAction()
            })
        alert.addAction(UIAlertAction(title: "我想 AA", style: UIAlertActionStyle.Default) { alert in
            self.alertAction()
            })
        
        alert.addAction(UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel, handler: nil))
 
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    public func alertAction(){
        self.isGoing = true
        self.tableView.reloadData();
    }
    
    deinit {
        println("deinit from detailviewcontroller")
    }
    
    public func shareSheetAction() {
        var someText = "blah"
        let google:NSURL = NSURL(string:"http://google.com/")!
        
        let activityViewController = UIActivityViewController(
            activityItems: [someText, google],
            applicationActivities:nil)
        self.presentViewController(activityViewController,
            animated: true,
            completion: nil)
    }
    
    public func callBusiness(){
        var phoneNumber = "tel:" + detailVM.detailBusinessInfoVM.phone!
        UIApplication.sharedApplication().openURL(NSURL (string: phoneNumber)!)
    }
    
    public func goToWebsiteUrl(){
        let businessName = detailVM.detailBusinessInfoVM.businessName
        let url = detailVM.detailBusinessInfoVM.websiteURL!
        let navController = UINavigationController()
        let webVC = DetailWebViewViewController(url: url, businessName: businessName)
        navController.pushViewController(webVC, animated: true)
        self.presentViewController(navController, animated: true, completion: nil)
    }
}

/**
*  UITableViewDataSource
*/
extension DetailViewController : UITableViewDataSource {
    /**
    Asks the data source to return the number of sections in the table view.
    
    :param: tableView An object representing the table view requesting this information.
    
    :returns: The number of sections in tableView. The default value is 1.
    */
    public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 5
    }
    
    /**
    Tells the data source to return the number of rows in a given section of a table view. (required)
    
    :param: tableView The table-view object requesting this information.
    :param: section   An index number identifying a section in tableView.
    
    :returns: The number of rows in section.
    */
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0:
            if (isGoing){
                return 3
            }else{
                return 2
            }
        case 1: return 2
        case 2: return 2
        case 3: return 2
        case 4: return 4
        default: return 1
        }
    }

    /**
    Asks the data source for a cell to insert in a particular location of the table view. (required)
    
    :param: tableView A table-view object requesting the cell.
    :param: indexPath An index path locating a row in tableView.
    
    :returns: An object inheriting from UITableViewCell that the table view can use for the specified row. An assertion is raised if you return nil
    */
    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

       var cell = DetailTableViewCell()
        return cell.createDetailViewCell(tableView, cellForRowAtIndexPath: indexPath, fromVC: self)
        
    }

    public func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        let row = indexPath.row
        let section = indexPath.section
        
        switch section {
            
        case 0:
            switch row {
            case 0: return 226
            case 1: return 65
            default: return 44
            }
            
        case 1:
            switch row {
            case 0: return 35
            default: return 70
            }
        case 2:
            switch row {
                
            case 1:
                if (expandHours){
                    return 215
                }else{
                    return 44
                }
            case 2: return 215
            default: return 35
            }
        case 3:
            switch row {
            case 1: return 91
            default: return 35
            }
        case 4:
            switch row {
            case 0: return 35
            case 1: return 226
            default: return 44
            }
        default: return 44
        }
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
extension DetailViewController : UITableViewDelegate {
    /**
    Tells the delegate that the specified row is now selected.
    
    :param: tableView A table-view object informing the delegate about the new row selection.
    :param: indexPath An index path locating the new selected row in tableView.
    */
    public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        if (indexPath.section == 2 && indexPath.row == 1){
            
            if (expandHours){
                expandHours = false
            }else{
               expandHours = true
            }
            
            tableView.reloadData()
        }
        
        if (indexPath.section == 0 && indexPath.row == 2){
            println("in here")
            
        }
        
        
    }
}