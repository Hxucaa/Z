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

public class PopulateParse {
    
    private typealias SaveTask = Task<Int, Bool, NSError>
    
    public init() {
        
    }
    
    public func populate() {
        populateFromJSON()
        
    }
    
//    public func featuredizeByNameSChinese(name: String) {
//        // create a task to find the business first
//        let queryTask =
//            Task<Int, [AnyObject], NSError> { progress, fulfill, reject, configure in
//                
//                var query = BusinessEntity.query()
//                query.whereKey("name_schinese", equalTo: name)
//                
//                query.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
//                    if error == nil {
//                        let count = objects.count
//                        if count > 1 {
//                            reject(NSError(domain: "There are \(count) business(es) sharing the same name.", code: 001, userInfo: nil))
//                        }
//                        else if count == 0 {
//                            reject(NSError(domain: "No business found", code: 000, userInfo: nil))
//                        }
//                        else {
//                            fulfill(objects)
//                        }
//                        
//                    }
//                    else {
//                        reject(error)
//                    }
//                })
//            }
//            .then { (objects, errorInfo) -> BusinessEntity? in
//                if errorInfo == nil {
//                    return (objects as? [BusinessEntity])?.first
//                }
//                else {
//                    return nil
//                }
//            }
//        
//        // create a task to save to the cloud
//        let saveTask = queryTask
//            .success { business -> SaveTask in
//                let featured = FeaturedEntity()
//                featured.timeStart = NSDate()
//                featured.timeEnd = NSDate()
//                featured.business = business
//                return self.createSaveInBackgroundTask(featured)
//            }
//        
//        // process save tasks
//        processAllSaveTasks([saveTask])
//    }
    
    private func populateFromJSON() {
        var businessEntityArr = loadBusinessesFromJSON("localBizInfo", ofType: "json")
        
        // launch all tasks
        let uploadTasks = businessEntityArr.map { (business: BusinessEntity) -> SaveTask in
            
            return BusinessInteractor().saveBusiness(business)
        }
        
        processAllSaveTasks(uploadTasks)
        
    }
    
    ///
    /// Process every save task.
    ///
    private func processAllSaveTasks(tasks: [SaveTask]) {
        // ensure all upload tasks are successful
        Task
            .all(tasks)
            .progress { (oldProgress, newProgress) -> Void in
                println("Progress: \(newProgress.completedCount)/\(newProgress.totalCount)")
                return
            }
            .success { successes -> Void in
                if $.every(successes, callback: { $0 }) && successes.count == tasks.count {
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
    private func loadBusinessesFromJSON(filename: String, ofType: String) -> [BusinessEntity] {
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
}