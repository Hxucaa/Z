//
//  DetailTableViewCell.swift
//  XListing
//
//  Created by Bruce Li on 2015-05-31.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import UIKit
import ReactKit
import MapKit

class DetailTableViewCell: NSObject, MKMapViewDelegate  {
    
    var mapView = MKMapView()

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
        self.reduceMargins(headerCell)
        return headerCell
    }
    
    func createCell(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, withIdentifier id:String) -> UITableViewCell{
        var cell =  tableView.dequeueReusableCellWithIdentifier(id, forIndexPath: indexPath) as! UITableViewCell
        self.reduceMargins(cell)
        return cell
    }
    
    func createDetailViewCell(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, fromVC dvc:DetailViewController) -> UITableViewCell {
        let row = indexPath.row
        let section = indexPath.section
        
        switch (section){
            
        case 0:
            switch (row){
            case 0:
                var imageCell = self.createCell(tableView, cellForRowAtIndexPath: indexPath, withIdentifier: "ImageCell")
                
                let businessImageView = dvc.view.viewWithTag(1) as? UIImageView
                
                dvc.coverImageNSURLStream = KVO.startingStream(dvc.detailVM.detailBusinessInfoVM, "coverImageNSURL")
                dvc.coverImageNSURLStream ~> { url in
                    if let url = url as? NSURL{
                        businessImageView?.sd_setImageWithURL(url)
                    }
                }
                return imageCell
            case 1:
                let bizInfoCell = self.createCell(tableView, cellForRowAtIndexPath: indexPath, withIdentifier: "BizInfoCell")
                
                let businessNameLabel : UILabel? = dvc.view.viewWithTag(1) as? UILabel
                let cityLabel : UILabel? = dvc.view.viewWithTag(2) as? UILabel
                let distanceLabel : UILabel? = dvc.view.viewWithTag(3) as? UILabel
                var wantToGoButton : UIButton? = dvc.view.viewWithTag(4) as? UIButton
                
                dvc.wantToGoButtonStream = wantToGoButton?.buttonStream("Want To Go Button")
                dvc.wantToGoButtonStream! ~> { _ in
                    dvc.wantToGoPopover()
                }
                
                if (dvc.isGoing){
                    wantToGoButton?.setTitle("\u{f004} 我想去", forState: UIControlState.Normal)
                }else{
                    wantToGoButton?.setTitle("\u{f08a} 我想去", forState: UIControlState.Normal)
                }
                
                
                dvc.businessNameStream = KVO.startingStream(dvc.detailVM.detailBusinessInfoVM, "businessName")
                (businessNameLabel!, "text") <~ dvc.businessNameStream
                
                dvc.cityAndDistanceStream = KVO.startingStream(dvc.detailVM.detailBusinessInfoVM, "cityAndDistance")
                (cityLabel!, "text") <~ dvc.cityAndDistanceStream
                
                //TODO:
                //Temp addition of ETA until the distance stream comes through
                cityLabel?.text = cityLabel!.text! + " • 开车15分钟"
                
                return bizInfoCell
                
            case 2: return self.createCell(tableView, cellForRowAtIndexPath: indexPath, withIdentifier: "NumPeopleGoingCell")
            default: self.defaultCell(tableView, cellForRowAtIndexPath: indexPath)
            }
            
        case 1:
            switch (row) {
            case 0: return self.headerCell(tableView, cellForRowAtIndexPath: indexPath, withTitle: "推荐物品")
            case 1: return self.createCell(tableView, cellForRowAtIndexPath: indexPath, withIdentifier: "WhatsGoodCell")
            default: return self.defaultCell(tableView, cellForRowAtIndexPath: indexPath)
            }

        case 2:
            switch (row) {
            case 0: return self.headerCell(tableView, cellForRowAtIndexPath: indexPath, withTitle: "营业时间")
            case 1:
                
                var hourCell : UITableViewCell
                
                if (dvc.expandHours){
                    hourCell = self.createCell(tableView, cellForRowAtIndexPath: indexPath, withIdentifier: "HoursCell")
                }else{
                    hourCell = self.createCell(tableView, cellForRowAtIndexPath: indexPath, withIdentifier: "CurrentHoursCell")
                    hourCell.accessoryView = UIImageView(image: UIImage(named:"downArrow"))
                    hourCell.textLabel?.text = "今天：10:30AM - 3:00PM  &  5:00PM - 11:00PM"
                }
                return hourCell

            default: return self.defaultCell(tableView, cellForRowAtIndexPath: indexPath)
            }
            
        case 3:
            switch (row) {
            case 0: return self.headerCell(tableView, cellForRowAtIndexPath: indexPath, withTitle:  "特设介绍")
            case 1: return self.createCell(tableView, cellForRowAtIndexPath: indexPath, withIdentifier: "DescriptionCell")
            default: return self.defaultCell(tableView, cellForRowAtIndexPath: indexPath)
            }
        case 4:
            switch (row){
            case 0: return self.headerCell(tableView, cellForRowAtIndexPath: indexPath, withTitle:  "地址和信息")
            case 1:
                var mapCell = self.createCell(tableView, cellForRowAtIndexPath: indexPath, withIdentifier: "MapCell")
                
                mapView = dvc.view.viewWithTag(1) as! MKMapView
                mapView.delegate = self
                
                let annotation = dvc.detailVM.detailBusinessInfoVM.mapAnnotation
                
                mapView.addAnnotation(annotation)
                
                let span = MKCoordinateSpanMake(0.01, 0.01)
                let region = MKCoordinateRegion(center: dvc.detailVM.detailBusinessInfoVM.cllocation.coordinate, span: span)
                mapView.setRegion(region, animated: false)
                
                return mapCell
            case 2:
                var addressCell = self.createCell(tableView, cellForRowAtIndexPath: indexPath, withIdentifier: "AddressCell")
                var addressButton : UIButton? = dvc.view.viewWithTag(1) as? UIButton
                
                let fullAddress = dvc.detailVM.detailBusinessInfoVM.fullAddress
                
                addressButton?.setTitle(fullAddress, forState: UIControlState.Normal)
                return addressCell
                
            case 3:
                var phoneWebSplitCell = self.createCell(tableView, cellForRowAtIndexPath: indexPath, withIdentifier: "PhoneWebSplitCell")
                var phoneNumberButton : UIButton? = dvc.view.viewWithTag(1) as? UIButton
                var websiteButton : UIButton? = dvc.view.viewWithTag(2) as? UIButton
                phoneNumberButton?.setTitle("   \u{f095}   " + (dvc.detailVM.detailBusinessInfoVM.phone)!, forState: UIControlState.Normal)
                
                if (dvc.detailVM.detailBusinessInfoVM.websiteURL != nil){
                    websiteButton?.setTitle("   \u{f0ac}   访问网站", forState: UIControlState.Normal)
                    websiteButton?.addTarget(self, action: "goToWebsiteUrl", forControlEvents: .TouchUpInside)
                } else{
                    websiteButton?.setTitle("   \u{f0ac}   没有网站", forState: UIControlState.Normal)
                }
                phoneNumberButton?.addTarget(self, action: "callBusiness", forControlEvents: .TouchUpInside)
        
                return phoneWebSplitCell
            default: return self.defaultCell(tableView, cellForRowAtIndexPath: indexPath)
            }
        default: return self.defaultCell(tableView, cellForRowAtIndexPath: indexPath)
        }
        return self.defaultCell(tableView, cellForRowAtIndexPath: indexPath)
    }
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
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
}
