//
//  DetailViewController.swift
//  XListing
//
//  Created by Lance Zhu on 2015-04-15.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import UIKit
import ReactKit
import Realm
import MapKit

public class DetailViewController : UIViewController {
    
    public var detailVM: IDetailViewModel?
    
    public var businessVM: BusinessViewModel?
    
    public var mapView = MKMapView?()
    
    @IBOutlet weak var tableView: UITableView!
    
  
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        self.navigationItem.title = businessVM?.nameSChinese
        println(businessVM!)
    }
    
    public override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    public override func viewDidDisappear(animated: Bool) {
        
        switch (mapView!.mapType) {
        case MKMapType.Hybrid:
            
                mapView?.mapType = MKMapType.Standard;
            
        case MKMapType.Standard:
                mapView?.mapType = MKMapType.Hybrid;

        default:
            break;
        }

        mapView?.removeFromSuperview()
        mapView = nil
    
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
        return 4
    }
    
    /**
    Tells the data source to return the number of rows in a given section of a table view. (required)
    
    :param: tableView The table-view object requesting this information.
    :param: section   An index number identifying a section in tableView.
    
    :returns: The number of rows in section.
    */
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0: return 3
        case 3: return 3
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

        let row = indexPath.row
        let section = indexPath.section
        
        
        
        switch (section){
        
        case 0:
            switch (row){
            case 0:
                var cell0 = tableView.dequeueReusableCellWithIdentifier("ImageCell", forIndexPath: indexPath) as! UITableViewCell
                
                let businessImageView = self.view.viewWithTag(1) as? UIImageView
                
                businessImageView!.hnk_setImageFromURL(NSURL(string: businessVM!.coverImageUrl!)!, failure: {
                    println("Image loading failed: \($0)")
                })
                
                return cell0
                
            case 1:
                var cell1 = tableView.dequeueReusableCellWithIdentifier("BizInfoCell", forIndexPath: indexPath) as! UITableViewCell
                
                var businessNameLabel : UILabel? = self.view.viewWithTag(1) as? UILabel
                var cityLabel : UILabel? = self.view.viewWithTag(2) as? UILabel
                var distanceLabel : UILabel? = self.view.viewWithTag(3) as? UILabel
                
                businessNameLabel?.text = businessVM?.nameSChinese
                cityLabel?.text = businessVM?.city
                distanceLabel?.text = businessVM?.distance
                
                return cell1
                
                
            case 2:
                var cell2 = tableView.dequeueReusableCellWithIdentifier("ButtonCell", forIndexPath: indexPath) as! UITableViewCell
            
                return cell2
                
            default:
                var placeHolderCell = tableView.dequeueReusableCellWithIdentifier("Placeholder", forIndexPath: indexPath) as! UITableViewCell
                return placeHolderCell
                
            }
            
        case 1:
            switch (row) {
            case 0:
                var cell3 = tableView.dequeueReusableCellWithIdentifier("HoursCell", forIndexPath: indexPath) as! UITableViewCell
                
                return cell3
                
            default:
                var placeHolderCell = tableView.dequeueReusableCellWithIdentifier("Placeholder", forIndexPath: indexPath) as! UITableViewCell
                return placeHolderCell

            }
            
        case 2:
            var cell4 = tableView.dequeueReusableCellWithIdentifier("DescriptionCell", forIndexPath: indexPath) as! UITableViewCell
            
            return cell4
            
        case 3:
            switch (row){
            case 0:
                var cell5 = tableView.dequeueReusableCellWithIdentifier("MapCell", forIndexPath: indexPath) as! UITableViewCell
                
                mapView = self.view.viewWithTag(1) as? MKMapView
                
                let annotation = MKPointAnnotation()
                annotation.coordinate = CLLocationCoordinate2D(latitude: businessVM!.latitude!, longitude: businessVM!.longitude!)
                annotation.title = businessVM!.nameSChinese
                annotation.subtitle = businessVM!.distance
                
                mapView?.addAnnotation(annotation)
                
                let span = MKCoordinateSpanMake(0.07, 0.07)
                let region = MKCoordinateRegion(center: CLLocationCoordinate2DMake(businessVM!.latitude!, businessVM!.longitude!), span: span)
                mapView!.setRegion(region, animated: false)
                
                return cell5
            case 1:
                var cell6 = tableView.dequeueReusableCellWithIdentifier("AddressCell", forIndexPath: indexPath) as! UITableViewCell
                var addressButton : UIButton? = self.view.viewWithTag(1) as? UIButton
                
                let address = businessVM?.address
                let city = businessVM?.city
                let state = businessVM?.state
                
                var fullAddress = address! + ", " + city! + ", " + state!

                addressButton?.setTitle(fullAddress, forState: UIControlState.Normal)
                return cell6
                
            case 2:
                var cell7 = tableView.dequeueReusableCellWithIdentifier("PhoneWebSplitCell", forIndexPath: indexPath) as! UITableViewCell
                var phoneNumberButton : UIButton? = self.view.viewWithTag(1) as? UIButton
                var websiteButton : UIButton? = self.view.viewWithTag(2) as? UIButton
                phoneNumberButton?.setTitle(businessVM?.phone, forState: UIControlState.Normal)

                websiteButton?.setTitle("访问网站", forState: UIControlState.Normal)
                return cell7
            default:
                var placeHolderCell = tableView.dequeueReusableCellWithIdentifier("Placeholder", forIndexPath: indexPath) as! UITableViewCell
                return placeHolderCell
            }
            
            
            
        default:
            var placeHolderCell = tableView.dequeueReusableCellWithIdentifier("Placeholder", forIndexPath: indexPath) as! UITableViewCell
            return placeHolderCell

        }
        
        
    }
    
    
    
    public func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        let row = indexPath.row
        let section = indexPath.section
        
        switch section {
            
        case 0:
            switch row {
            case 0: return 226
            default: return 58
            }
        case 1:
            return 215
        case 2:
            return 91
        case 3:
            switch row {
            case 0: return 226
            default: return 44
            }
            
        default: return 44
        }
        
        
        
    }
    
    public func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 1: return "营业时间"
        case 2: return "特设介绍"
        case 3: return "地址和信息"
        default: return ""
        }
    }
    
    public func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
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
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        
    }
}