//
//  DetailViewController.swift
//  XListing
//
//  Created by Lance Zhu on 2015-04-15.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import UIKit
import ReactiveCocoa
import MapKit
import WebKit

public final class DetailViewController : XUIViewController, MKMapViewDelegate {
    
    private var viewmodel: IDetailViewModel!
    
    public var expandHours: Bool = false
    
    @IBOutlet weak var tableView: UITableView!
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        navigationItem.rac_title <~ viewmodel.businessName
    }
    
    public override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    public func bindToViewModel(detailViewModel: IDetailViewModel) {
        viewmodel = detailViewModel
    }
    
    @IBAction func shareButtonTapped(sender: AnyObject) {
        self.shareSheetAction()
    }
    
    public func shareSheetAction() {
        var someText = "blah"
        let google = NSURL(string:"http://google.com/")!
        
        let activityViewController = UIActivityViewController(
            activityItems: [someText, google],
            applicationActivities:nil)
        self.presentViewController(activityViewController,
            animated: true,
            completion: nil)
    }
}

    private func reduceMargins(cell:UITableViewCell) {
        cell.layoutMargins = UIEdgeInsetsZero;
        cell.preservesSuperviewLayoutMargins = false;
    }

    private func defaultCell(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var placeHolderCell = tableView.dequeueReusableCellWithIdentifier("Placeholder", forIndexPath: indexPath) as! UITableViewCell
        return placeHolderCell
    }

    private func headerCell(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, withTitle title: String) -> UITableViewCell {
        var headerCell = tableView.dequeueReusableCellWithIdentifier("Placeholder", forIndexPath: indexPath) as! UITableViewCell
        headerCell.textLabel?.text = title
        reduceMargins(headerCell)
        return headerCell
    }

    private func createCell(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, withIdentifier id:String) -> UITableViewCell {
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
                let imageCell = createCell(tableView, cellForRowAtIndexPath: indexPath, withIdentifier: "ImageCell") as! DetailImageTableViewCell
                imageCell.bindToViewModel(viewmodel.detailImageViewModel)
                return imageCell
            case 1:
                
                var bizInfoCell = createCell(tableView, cellForRowAtIndexPath: indexPath, withIdentifier: "BizInfoCell") as! DetailBizInfoTableViewCell
                
                bizInfoCell.delegate = self
                bizInfoCell.bindToViewModel(viewmodel.detailBizInfoViewModel)
                
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
            case 0:
                return headerCell(tableView, cellForRowAtIndexPath: indexPath, withTitle: "地址和信息")
            case 1:
                let mapCell = createCell(tableView, cellForRowAtIndexPath: indexPath, withIdentifier: "MapCell") as! DetailMapTableViewCell
                mapCell.delegate = self
                mapCell.bindToViewModel(viewmodel.detailAddressAndMapViewModel)
                return mapCell
            case 2:
                let addressCell = createCell(tableView, cellForRowAtIndexPath: indexPath, withIdentifier: "AddressCell") as! DetailAddressTableViewCell
                addressCell.delegate = self
                addressCell.bindToViewModel(viewmodel.detailAddressAndMapViewModel)
                return addressCell
            case 3:
                let phoneWebCell = createCell(tableView, cellForRowAtIndexPath: indexPath, withIdentifier: "PhoneWebSplitCell") as! DetailPhoneWebTableViewCell
                
                phoneWebCell.delegate = self
                phoneWebCell.bindToViewModel(viewmodel.detailPhoneWebViewModel)
                
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
    public func participate<T: UIViewController>(viewController: T) {
        self.presentViewController(viewController, animated: true, completion: nil)
    }
}

extension DetailViewController : ParticipationPopoverDelegate {
    public func alertAction(choiceTag: Int) {
        self.tableView.reloadData()
    }
}

extension DetailViewController : DetailPhoneWebCellDelegate {
    public func presentWebView<T: UIViewController>(viewController: T) {
        self.presentViewController(viewController, animated: true, completion: nil)
    }
}

extension DetailViewController : AddressAndMapDelegate {
    public func pushNavigationMapViewController<T: UIViewController>(viewController: T) {
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}