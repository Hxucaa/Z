//
//  PopulateParse.swift
//  XListing
//
//  Created by Lance Zhu on 2015-03-07.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import SwiftyJSON

class PopulateParse {
    class func populate() {
        println("############ Populating Database (Ignore warnings) ############")
        //populateFromPlist()
        populateFromJSON()
        println("############ Populating Completed ############")
    }
    
    private class func populateFromJSON() {
        let businessEntityArr = fromJSON()
        for item in businessEntityArr {
            item.save()
        }
    }
    
    private class func populateFromPlist() {
        var businesses = loadBusiness("BusinessPop")
        var featureds = loadFeatured("FeaturedPop")
        
        featureds[0].business = businesses[0]
        featureds[1].business = businesses[1]
        featureds[2].business = businesses[2]
        
        for f in featureds {
            f.save()
        }
    }
    
    private class func fromJSON() -> [BusinessEntity] {
        let path = NSBundle.mainBundle().pathForResource("localBizInfo", ofType: "json")
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
    
    private class func loadBusiness(filename: String) -> [BusinessEntity] {
        var businesses = [BusinessEntity]()
        
        let businessArray = loadFromPlist(filename)
        for business in businessArray {
            let busDict = business as NSDictionary
            var newBus = BusinessEntity()
            newBus.isClaimed = busDict["isClaimed"] as? Bool
            newBus.isClosed = busDict["isClosed"] as? Bool
            newBus.nameSChinese = busDict["nameSChinese"] as? String
            newBus.nameTChinese = busDict["nameTChinese"] as? String
            newBus.nameEnglish = busDict["nameEnglish"] as? String
            newBus.imageUrl = busDict["imageUrl"] as? String
            newBus.url = busDict["url"] as? String
            newBus.mobileUrl = busDict["mobileUrl"] as? String
            newBus.phone = busDict["phone"] as? String
//            newBus.displayPhone = busDict["displayPhone"] as String
            newBus.uid = busDict["uid"] as? String
            newBus.reviewCount = busDict["reviewCount"] as? Int
            newBus.rating = busDict["rating"] as? Double
            
            var loc = LocationEntity()
            if let locDict = busDict["location"] as? NSDictionary {
                loc.unit = locDict["unit"] as? String
                loc.address = locDict["address"] as? String
                loc.district = locDict["district"] as? String
                loc.city = locDict["city"] as? String
                loc.state = locDict["state"] as? String
                loc.postalCode = locDict["postalCode"] as? String
                loc.country = locDict["country"] as? String
                loc.crossStreets = locDict["crossStreets"] as? String
                loc.neighborhoods = locDict["neighborhoods"] as? [String]
            }
            
            newBus.location = loc
            
            businesses.append(newBus)
        }
        return businesses
    }
    
    
    private class func loadFeatured(filename: String) -> [FeaturedEntity] {
        var featureds = [FeaturedEntity]()
        
        let featuredArray = loadFromPlist(filename)
        for featured in featuredArray {
            let feaDict = featured as NSDictionary
            var newFea = FeaturedEntity()
            newFea.timeStart = feaDict["timeStart"] as? NSDate
            newFea.timeEnd = feaDict["timeEnd"] as? NSDate
            
            featureds.append(newFea)
        }
        return featureds
    }
    
    private class func loadFromPlist(filename: String) -> NSArray {
        let path = NSBundle.mainBundle().pathForResource(filename, ofType: "plist")
        
        var array = NSArray(contentsOfFile: path!)!
        return array
    }
}