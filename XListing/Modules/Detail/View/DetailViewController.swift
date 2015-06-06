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
import SDWebImage

private let CityDistanceSeparator = " • "

public final class DetailViewController : UIViewController, MKMapViewDelegate {
    
    private var detailVM: IDetailViewModel!
    
    public var expandHours: Bool = false
    public var isGoing: Bool = false
    
    @IBOutlet weak var tableView: UITableView!
    
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
    
    public func bindToViewModel(detailViewModel: IDetailViewModel) {
        detailVM = detailViewModel
    }
    
    @IBAction func shareButtonTapped(sender: AnyObject) {
        self.shareSheetAction()
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

    func reduceMargins(cell:UITableViewCell) {
        cell.layoutMargins = UIEdgeInsetsZero;
        cell.preservesSuperviewLayoutMargins = false;
    }

    func defaultCell(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var placeHolderCell = tableView.dequeueReusableCellWithIdentifier("Placeholder", forIndexPath: indexPath) as! UITableViewCell
        return placeHolderCell
    }

    func headerCell(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, withTitle title: String) -> UITableViewCell {
        var headerCell = tableView.dequeueReusableCellWithIdentifier("Placeholder", forIndexPath: indexPath) as! UITableViewCell
        headerCell.textLabel?.text = title
        reduceMargins(headerCell)
        return headerCell
    }

    func createCell(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, withIdentifier id:String) -> UITableViewCell{
        var cell =  tableView.dequeueReusableCellWithIdentifier(id, forIndexPath: indexPath) as! UITableViewCell
        reduceMargins(cell)
        return cell
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
        
        let row = indexPath.row
        let section = indexPath.section
        
        switch (section){
            
        case 0:
            switch (row){
            case 0:
                var imageCell = createCell(tableView, cellForRowAtIndexPath: indexPath, withIdentifier: "ImageCell") as! DetailImageTableViewCell
                
                coverImageNSURLStream = KVO.startingStream(detailVM.detailBusinessInfoVM, "coverImageNSURL")
                coverImageNSURLStream ~> { url in
                    if let url = url as? NSURL{
                        imageCell.detailImageView.sd_setImageWithURL(url)
                    }
                }
                
                return imageCell
            case 1:
                
                var bizInfoCell = createCell(tableView, cellForRowAtIndexPath: indexPath, withIdentifier: "BizInfoCell") as! DetailBizInfoTableViewCell
                
                bizInfoCell.delegate = self
                
                if (isGoing){
                    bizInfoCell.participateButton.setTitle("\u{f004} 我想去", forState: UIControlState.Normal)
                }else{
                    bizInfoCell.participateButton.setTitle("\u{f08a} 我想去", forState: UIControlState.Normal)
                }
                
                businessNameStream = KVO.startingStream(detailVM.detailBusinessInfoVM, "businessName")
                (bizInfoCell.businessNameLabel!, "text") <~ businessNameStream
                
                cityAndDistanceStream = KVO.startingStream(detailVM.detailBusinessInfoVM, "cityAndDistance")
                (bizInfoCell.cityAndDistanceLabel!, "text") <~ cityAndDistanceStream
                
                //TODO:
                //Temp addition of ETA until the distance stream comes through
                bizInfoCell.cityAndDistanceLabel.text = bizInfoCell.cityAndDistanceLabel.text! + " • 开车15分钟"
                
                return bizInfoCell
                
            case 2: return createCell(tableView, cellForRowAtIndexPath: indexPath, withIdentifier: "NumPeopleGoingCell")
            default: return defaultCell(tableView, cellForRowAtIndexPath: indexPath)
            }
            
        case 1:
            switch (row) {
            case 0: return headerCell(tableView, cellForRowAtIndexPath: indexPath, withTitle: "推荐物品")
            case 1: return createCell(tableView, cellForRowAtIndexPath: indexPath, withIdentifier: "WhatsGoodCell")
            default: return defaultCell(tableView, cellForRowAtIndexPath: indexPath)
            }
            
        case 2:
            switch (row) {
            case 0: return headerCell(tableView, cellForRowAtIndexPath: indexPath, withTitle: "营业时间")
            case 1:
                if (expandHours){ return createCell(tableView, cellForRowAtIndexPath: indexPath, withIdentifier: "HoursCell")
                }else{
                    var hourCell = createCell(tableView, cellForRowAtIndexPath: indexPath, withIdentifier: "CurrentHoursCell")
                    hourCell.accessoryView = UIImageView(image: UIImage(named:"downArrow"))
                    hourCell.textLabel?.text = "今天：10:30AM - 3:00PM  &  5:00PM - 11:00PM"
                    return hourCell
                }
            default: return defaultCell(tableView, cellForRowAtIndexPath: indexPath)
            }
            
        case 3:
            switch (row) {
            case 0: return headerCell(tableView, cellForRowAtIndexPath: indexPath, withTitle: "特设介绍")
            case 1: return createCell(tableView, cellForRowAtIndexPath: indexPath, withIdentifier: "DescriptionCell")
            default: return defaultCell(tableView, cellForRowAtIndexPath: indexPath)
            }
            
        case 4:
            switch (row){
            case 0: return headerCell(tableView, cellForRowAtIndexPath: indexPath, withTitle: "地址和信息")
            case 1:
                var mapCell = createCell(tableView, cellForRowAtIndexPath: indexPath, withIdentifier: "MapCell") as! DetailMapTableViewCell
                
                let annotation = detailVM.detailBusinessInfoVM.mapAnnotation
                mapCell.mapView.addAnnotation(annotation)
       
                let span = MKCoordinateSpanMake(0.01, 0.01)
                let region = MKCoordinateRegion(center: detailVM.detailBusinessInfoVM.cllocation.coordinate, span: span)
                mapCell.mapView.setRegion(region, animated: false)
                
                var tapGesture = UITapGestureRecognizer(target: self, action: "goToMapVC")
                mapCell.mapView.addGestureRecognizer(tapGesture)
                
                return mapCell
            case 2:
                var addressCell = createCell(tableView, cellForRowAtIndexPath: indexPath, withIdentifier: "AddressCell") as! DetailAddressTableViewCell
                
                let fullAddress = detailVM.detailBusinessInfoVM.fullAddress
                
                addressCell.addressButton.setTitle(fullAddress, forState: UIControlState.Normal)
                return addressCell
                
            case 3:
                
                var phoneWebCell = createCell(tableView, cellForRowAtIndexPath: indexPath, withIdentifier: "PhoneWebSplitCell") as! DetailPhoneWebTableViewCell
                
                phoneWebCell.phoneButton?.setTitle("   \u{f095}   " + (detailVM.detailBusinessInfoVM.phone)!, forState: UIControlState.Normal)
                
                phoneWebCell.delegate = self
                
                if (detailVM.detailBusinessInfoVM.websiteURL != nil){
                    phoneWebCell.websiteButton?.setTitle("   \u{f0ac}   访问网站", forState: UIControlState.Normal)
                } else{
                    phoneWebCell.websiteButton?.setTitle("   \u{f0ac}   没有网站", forState: UIControlState.Normal)
                }
                
                return phoneWebCell
            default: return defaultCell(tableView, cellForRowAtIndexPath: indexPath)
            }
        default:return defaultCell(tableView, cellForRowAtIndexPath: indexPath)
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
            DetailLogDebug("in here")
            
        }
    }
}

extension DetailViewController : DetailBizInfoCellDelegate{
    public func participate() {
        wantToGoPopover()
    }
}

extension DetailViewController : DetailPhoneWebCellDelegate {
    public func goToWebsite() {
        goToWebsiteUrl()
    }
    
    public func callPhone() {
        callBusiness()
    }
}

extension DetailViewController : DetailAddressCellDelegate {
    public func goToMapVC() {
        let locationStream = detailVM.getCurrentLocation()
        locationStream.ownedBy(self)
        locationStream ~> { [unowned self] location -> Void in
            var businessMapVC = DetailBusinessMapViewController(nibName: "DetailBusinessMapViewController", bundle: nil)
            var distance = self.detailVM.detailBusinessInfoVM.cllocation.distanceFromLocation(location)
            var spanFactor = distance / 55000.00
            let span = MKCoordinateSpanMake(spanFactor, spanFactor)
            let region = MKCoordinateRegion(center: self.detailVM.detailBusinessInfoVM.cllocation.coordinate, span: span)
            let annotation = self.detailVM.detailBusinessInfoVM.mapAnnotation
            businessMapVC.region = region
            businessMapVC.businessAnnotation = annotation
            self.navigationController?.pushViewController(businessMapVC, animated: true)
        }
    }
}