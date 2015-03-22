//
//  PopulateParse.swift
//  XListing
//
//  Created by Lance Zhu on 2015-03-07.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import SwiftyJSON
import SwiftTask
import Dollar

class PopulateParse {
    
    typealias saveTask = Task<Int, Bool, NSError>
    
    init() {
        
    }
    
    func populate() {
        populateFromJSON()
    }
    
    private func populateFromJSON() {
        var businessEntityArr = fromJSON("localBizInfo", ofType: "json")
        
        // launch all tasks
        let uploadTasks = businessEntityArr.map { (business: BusinessEntity) -> saveTask in
            let l = business.location!
            let addressString = "\(l.address!) \(l.city!) \(l.state!) \(l.country!)"
            
            return self.uploadToParse(business, addressString: addressString)
        }
        
        // ensure all upload tasks are successful
        Task
            .all(uploadTasks)
            .progress { (oldProgress, newProgress) -> Void in
                println("Progress: \(newProgress.completedCount)/\(newProgress.totalCount)")
                return
            }
            .success { successes -> Void in
                if $.every(successes, callback: { $0 }) && businessEntityArr.count {
                    println("Upload data to server completes successfully!")
                }
                else {
                    println("Upload fails!")
                }
            }
            .failure { (error, isCancelled) -> Void in
                if let error = error {
                    println("Error: \(error.localizedDescription)")
                }
                if isCancelled {
                    println("Tasks cancelled!")
                }
            }
        
    }
    
    ///
    /// Load data from JSON file
    ///
    private func fromJSON(filename: String, ofType: String) -> [BusinessEntity] {
        let path = NSBundle.mainBundle().pathForResource(filename, ofType: ofType)
        let jsonData = NSData(contentsOfFile: path!, options: .DataReadingMappedIfSafe, error: nil)
        let json = JSON(data: jsonData!)
        var businessEntityArr = [BusinessEntity]()
        
        for(index: String, subJson: JSON) in json {
            var b = BusinessEntity()
            var l = LocationEntity()
            
            if let name = subJson["nameSChinese"].string {
                b.nameSChinese = name
            }
            if let name = subJson["nameTChinese"].string {
                b.nameTChinese = name
            }
            if let name = subJson["nameEnglish"].string {
                b.nameEnglish = name
            }
            if let isClaimed = subJson["isClaimed"].bool {
                b.isClaimed = isClaimed
            }
            if let isClosed = subJson["isClosed"].bool {
                b.isClosed = isClosed
            }
            if let phone = subJson["phone"].string {
                b.phone = phone
            }
            if let url = subJson["url"].string {
                b.url = url
            }
            if let mobileUrl = subJson["mobileUrl"].string {
                b.mobileUrl = mobileUrl
            }
            if let uid = subJson["uid"].string {
                b.uid = uid
            }
            if let imageUrl = subJson["imageUrl"].string {
                b.imageUrl = imageUrl
            }
            if let reviewCount = subJson["reviewCount"].int {
                b.reviewCount = reviewCount
            }
            if let rating = subJson["rating"].double {
                b.rating = rating
            }
            if let unit = subJson["unit"].string {
                l.unit = unit
            }
            if let address = subJson["address"].string {
                l.address = address
            }
            if let district = subJson["district"].string {
                l.district = district
            }
            if let city = subJson["city"].string {
                l.city = city
            }
            if let state = subJson["state"].string {
                l.state = state
            }
            if let country = subJson["country"].string {
                l.country = country
            }
            if let postalCode = subJson["postalCode"].string {
                l.postalCode = postalCode
            }
            if let crossStreets = subJson["crossStreets"].string {
                l.crossStreets = crossStreets
            }
            
            b.location = l
            businessEntityArr.append(b)
        }
        return businessEntityArr
    }
    
    ///
    /// Upload to Parse server
    ///
    private func uploadToParse(business: BusinessEntity, addressString: String) -> saveTask {
        
        // translate address to geo location coordinates
        let forwardGeocodingTask = Task<Int, [AnyObject], NSError> { progress, fulfill, reject, configure in
            CLGeocoder().geocodeAddressString(addressString, completionHandler: { (placemarks: [AnyObject]!, error: NSError!) -> Void in
                if error == nil && placemarks.count > 0 {
                    fulfill(placemarks)
                }
                else {
                    reject(error)
                }
            })
        }
        
        let resultTask = forwardGeocodingTask
            .success { (placemarks: [AnyObject]) -> saveTask in
                // upload to parse
                func saveToParse(business: BusinessEntity) -> saveTask {
                    let task = Task<Int, Bool, NSError> { progress, fulfill, reject, configure in
                        business.saveInBackgroundWithBlock { (success, error) -> Void in
                            if success {
                                fulfill(success)
                            }
                            else {
                                reject(error)
                            }
                        }
                    }
                    return task
                }
                
                // convert to PFGeoPoint
                let placemark = placemarks[0] as CLPlacemark
                let location = placemark.location
                let geopoint = PFGeoPoint(location: location)
                
                business.location?.geopoint = geopoint
                
                return saveToParse(business)
            }
            .failure { (error: NSError?, isCancelled: Bool) -> Bool in
                if let error = error {
                    println("Forward geocoding failed with error: \(error.localizedDescription)")
                }
                if isCancelled {
                    println("Forward geocoding cancelled")
                }
                return false
            }
        return resultTask
    }
}