//
//  PopulateParse.swift
//  XListing
//
//  Created by Lance Zhu on 2015-03-07.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation

class PopulateParse {
    class func Populate() {
        println("############ Populating Database (Ignore warnings) ############")
        var businesses = loadBusiness("BusinessPop")
        var featureds = loadFeatured("FeaturedPop")
        
        featureds[0].business = businesses[0]
        featureds[1].business = businesses[1]
        featureds[2].business = businesses[2]
        
        for f in featureds {
            f.save()
        }
        println("############ Populating Completed ############")
    }
    
    private class func loadBusiness(filename: String) -> [BusinessEntity] {
        var businesses = [BusinessEntity]()
        
        let businessArray = loadFromPlist(filename)
        for business in businessArray {
            let busDict = business as NSDictionary
            var newBus = BusinessEntity()
            newBus.isClaimed = busDict["isClaimed"] as Bool
            newBus.isClosed = busDict["isClosed"] as Bool
            newBus.name = busDict["name"] as String
            newBus.imageUrl = busDict["imageUrl"] as String
            newBus.url = busDict["url"] as String
            newBus.mobileUrl = busDict["mobileUrl"] as String
            newBus.phone = busDict["phone"] as String
            newBus.displayPhone = busDict["displayPhone"] as String
            newBus.reviewCount = busDict["reviewCount"] as Int
            newBus.rating = busDict["rating"] as? Double
            
            let locDict = busDict["location"] as NSDictionary
            var loc = LocationEntity()
            loc.address = locDict["address"] as [String]
            loc.city = locDict["city"] as String
            loc.stateCode = locDict["stateCode"] as String
            loc.postalCode = locDict["postalCode"] as String
            loc.countryCode = locDict["countryCode"] as String
            loc.crossStreets = locDict["crossStreets"] as? String
            loc.neighborhoods = locDict["neighborhoods"] as [String]
            
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
            newFea.timeStart = feaDict["timeStart"] as NSDate
            newFea.timeEnd = feaDict["timeEnd"] as NSDate
            
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