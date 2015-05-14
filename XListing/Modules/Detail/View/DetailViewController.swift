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
    
    @IBOutlet weak var tableView: UITableView!
    
    private var businessNameStream: Stream<AnyObject?>!
    private var cityAndDistanceStream: Stream<AnyObject?>!
    private var wantToGoButtonStream: Stream<String>!
    private var shareButtonStream: Stream<String>!
    private var coverImageNSURLStream: Stream<AnyObject?>!

    public override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        //tableView.allowsSelection = false
        
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
        
        println("view did disappear")
    
    }
    
//    public override func viewDidAppear(animated: Bool) {
//        tableView.reloadData()
//        println("did appear")
//    }
    
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
        var alert = UIAlertController(title: "什么时候想去？", message: "", preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(title: "这个星期", style: UIAlertActionStyle.Default) { alert in
            detailVM.goingToBusiness(thisWeek: true, thisMonth: false, later: false)
            })
            
            
        alert.addAction(UIAlertAction(title: "这个月", style: UIAlertActionStyle.Default) { alert in
            detailVM.goingToBusiness(thisWeek: false, thisMonth: true, later: false)
            })
        
        alert.addAction(UIAlertAction(title: "以后", style: UIAlertActionStyle.Default) { alert in
            detailVM.goingToBusiness(thisWeek: false, thisMonth: false, later: true)
            })
        
        alert.addAction(UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel, handler: nil))
        
        self.presentViewController(alert, animated: true, completion: nil)
     
        
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
//        NSString *phoneNumber = [@"tel://" stringByAppendingString:mymobileNO.titleLabel.text];
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
        
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
        case 0: return 3
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

        let row = indexPath.row
        let section = indexPath.section
        
        
        
        switch (section){
        
        case 0:
            switch (row){
            case 0:
                var cell0 = tableView.dequeueReusableCellWithIdentifier("ImageCell", forIndexPath: indexPath) as! UITableViewCell
                
                cell0.layoutMargins = UIEdgeInsetsZero;
                cell0.preservesSuperviewLayoutMargins = false;
                
                let businessImageView = self.view.viewWithTag(1) as? UIImageView
                
                coverImageNSURLStream = KVO.startingStream(detailVM.detailBusinessInfoVM, "coverImageNSURL")
                coverImageNSURLStream ~> { url in
                    if let url = url as? NSURL{
                        businessImageView!.hnk_setImageFromURL(url, failure: {
                            println("Image loading failed: \($0)")
                        })
                    }
                }
                
                
                return cell0
                
            case 1:
                let cell1 = tableView.dequeueReusableCellWithIdentifier("BizInfoCell", forIndexPath: indexPath) as! UITableViewCell
                
                cell1.layoutMargins = UIEdgeInsetsZero;
                cell1.preservesSuperviewLayoutMargins = false;
                
                let businessNameLabel : UILabel? = self.view.viewWithTag(1) as? UILabel
                let cityLabel : UILabel? = self.view.viewWithTag(2) as? UILabel
                let distanceLabel : UILabel? = self.view.viewWithTag(3) as? UILabel
                
                businessNameStream = KVO.startingStream(detailVM.detailBusinessInfoVM, "businessName")
                (businessNameLabel!, "text") <~ businessNameStream
                
                cityAndDistanceStream = KVO.startingStream(detailVM.detailBusinessInfoVM, "cityAndDistance")
                (cityLabel!, "text") <~ cityAndDistanceStream
                
                return cell1
                
                
            case 2:
                let cell2 = tableView.dequeueReusableCellWithIdentifier("ButtonCell", forIndexPath: indexPath) as! UITableViewCell
                
                cell2.layoutMargins = UIEdgeInsetsZero;
                cell2.preservesSuperviewLayoutMargins = false;
                
                let wantToGoButton : UIButton? = self.view.viewWithTag(1) as? UIButton
                let shareButton : UIButton? = self.view.viewWithTag(2) as? UIButton
                
                wantToGoButtonStream = wantToGoButton?.buttonStream("Want To Go Button")
                wantToGoButtonStream! ~> { _ in
                    self.wantToGoPopover()
                }

                shareButtonStream = shareButton?.buttonStream("Share Button")
                shareButtonStream! ~> { _ in
                    self.shareSheetAction()
                }

                return cell2
                
            case 3:
                var cell3 = tableView.dequeueReusableCellWithIdentifier("MenuCell", forIndexPath: indexPath) as! UITableViewCell
                
                cell3.layoutMargins = UIEdgeInsetsZero;
                cell3.preservesSuperviewLayoutMargins = false;
                
                cell3.textLabel?.text = "查看菜单"
                
                return cell3
                
            default:
                var placeHolderCell = tableView.dequeueReusableCellWithIdentifier("Placeholder", forIndexPath: indexPath) as! UITableViewCell
                return placeHolderCell
                
            }
            
        case 1:
            switch (row) {
            case 0:
                var placeHolderCell = tableView.dequeueReusableCellWithIdentifier("Placeholder", forIndexPath: indexPath) as! UITableViewCell
                
                placeHolderCell.layoutMargins = UIEdgeInsetsZero;
                placeHolderCell.preservesSuperviewLayoutMargins = false;
                
                placeHolderCell.textLabel?.text = "推荐物品"
                
                return placeHolderCell
            
            
            case 1:
                var whatsGoodCell =  tableView.dequeueReusableCellWithIdentifier("WhatsGoodCell", forIndexPath: indexPath) as! UITableViewCell
            
                whatsGoodCell.layoutMargins = UIEdgeInsetsZero
                whatsGoodCell.preservesSuperviewLayoutMargins = false
            
                return whatsGoodCell
            
            default:
                var placeHolderCell = tableView.dequeueReusableCellWithIdentifier("Placeholder", forIndexPath: indexPath) as! UITableViewCell
                return placeHolderCell
            
            }
        
            
            
        case 2:
            switch (row) {
            case 0:
                var placeHolderCell = tableView.dequeueReusableCellWithIdentifier("Placeholder", forIndexPath: indexPath) as! UITableViewCell
                
                placeHolderCell.layoutMargins = UIEdgeInsetsZero;
                placeHolderCell.preservesSuperviewLayoutMargins = false;
                
                placeHolderCell.textLabel?.text = "营业时间"
                
                return placeHolderCell
              
                
            case 1:
                
            
                var hourCell : UITableViewCell
                
                
                if (expandHours){
                    hourCell = tableView.dequeueReusableCellWithIdentifier("HoursCell", forIndexPath: indexPath) as! UITableViewCell
                }else{
                    hourCell = tableView.dequeueReusableCellWithIdentifier("CurrentHoursCell", forIndexPath: indexPath) as! UITableViewCell
                    
                    hourCell.accessoryView = UIImageView(image: UIImage(named:"downArrow"))
                    
                    hourCell.textLabel?.text = "今天：10:30AM - 3:00PM  &  5:00PM - 11:00PM"
                    
            
                }
                
                hourCell.layoutMargins = UIEdgeInsetsZero;
                hourCell.preservesSuperviewLayoutMargins = false;
                
                return hourCell
                
            case 2:
                var cell4 = tableView.dequeueReusableCellWithIdentifier("HoursCell", forIndexPath: indexPath) as! UITableViewCell
                
                cell4.layoutMargins = UIEdgeInsetsZero;
                cell4.preservesSuperviewLayoutMargins = false;
                
                return cell4
                
            default:
                var placeHolderCell = tableView.dequeueReusableCellWithIdentifier("Placeholder", forIndexPath: indexPath) as! UITableViewCell
                return placeHolderCell

            }
            
        case 3:
            switch (row) {
            case 0:
                var placeHolderCell = tableView.dequeueReusableCellWithIdentifier("Placeholder", forIndexPath: indexPath) as! UITableViewCell
                
                placeHolderCell.layoutMargins = UIEdgeInsetsZero;
                placeHolderCell.preservesSuperviewLayoutMargins = false;
                
                placeHolderCell.textLabel?.text = "特设介绍"
                
                return placeHolderCell
            case 1:
            var cell5 = tableView.dequeueReusableCellWithIdentifier("DescriptionCell", forIndexPath: indexPath) as! UITableViewCell
            
            cell5.layoutMargins = UIEdgeInsetsZero;
            cell5.preservesSuperviewLayoutMargins = false;
            
            return cell5
                
            default:
                var placeHolderCell = tableView.dequeueReusableCellWithIdentifier("Placeholder", forIndexPath: indexPath) as! UITableViewCell
                return placeHolderCell
            }
        case 4:
            switch (row){
            case 0:
                var placeHolderCell = tableView.dequeueReusableCellWithIdentifier("Placeholder", forIndexPath: indexPath) as! UITableViewCell
                
                placeHolderCell.layoutMargins = UIEdgeInsetsZero;
                placeHolderCell.preservesSuperviewLayoutMargins = false;
                
                placeHolderCell.textLabel?.text = "地址和信息"
                
                return placeHolderCell
            case 1:
                var cell6 = tableView.dequeueReusableCellWithIdentifier("MapCell", forIndexPath: indexPath) as! UITableViewCell
                
                cell6.layoutMargins = UIEdgeInsetsZero;
                cell6.preservesSuperviewLayoutMargins = false;
                
                mapView = view.viewWithTag(1) as! MKMapView
                mapView.delegate = self
                
                let annotation = detailVM.detailBusinessInfoVM.mapAnnotation
                
                mapView.addAnnotation(annotation)
                
                let span = MKCoordinateSpanMake(0.01, 0.01)
                let region = MKCoordinateRegion(center: detailVM.detailBusinessInfoVM.cllocation.coordinate, span: span)
                mapView.setRegion(region, animated: false)
                
                return cell6
            case 2:
                var cell7 = tableView.dequeueReusableCellWithIdentifier("AddressCell", forIndexPath: indexPath) as! UITableViewCell
                
                cell7.layoutMargins = UIEdgeInsetsZero;
                cell7.preservesSuperviewLayoutMargins = false;
                
                var addressButton : UIButton? = view.viewWithTag(1) as? UIButton
                
                let fullAddress = detailVM.detailBusinessInfoVM.fullAddress

                addressButton?.setTitle(fullAddress, forState: UIControlState.Normal)
                return cell7
                
            case 3:
                var cell8 = tableView.dequeueReusableCellWithIdentifier("PhoneWebSplitCell", forIndexPath: indexPath) as! UITableViewCell
                
                cell8.layoutMargins = UIEdgeInsetsZero;
                cell8.preservesSuperviewLayoutMargins = false;
                
                var phoneNumberButton : UIButton? = self.view.viewWithTag(1) as? UIButton
                var websiteButton : UIButton? = self.view.viewWithTag(2) as? UIButton
                phoneNumberButton?.setTitle("   \u{f095}   " + (detailVM.detailBusinessInfoVM.phone)!, forState: UIControlState.Normal)
                
                if (detailVM.detailBusinessInfoVM.websiteURL != nil){
                    websiteButton?.setTitle("   \u{f0ac}   访问网站", forState: UIControlState.Normal)
                    websiteButton?.addTarget(self, action: "goToWebsiteUrl", forControlEvents: .TouchUpInside)
                } else{
                    websiteButton?.setTitle("   \u{f0ac}   没有网站", forState: UIControlState.Normal)
                }

                
                
                phoneNumberButton?.addTarget(self, action: "callBusiness", forControlEvents: .TouchUpInside)
                
                
                
                return cell8
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
            case 1: return 65
            case 2: return 86
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
    
    public func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {

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
        //tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        if (indexPath.section == 2 && indexPath.row == 1){
            
            if (expandHours){
                expandHours = false
            }else{
               expandHours = true
            }
            
            tableView.reloadData()
        }
        
        
    }
}