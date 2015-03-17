//
//  ListManager.swift
//  XListing
//
//  Created by Lance Zhu on 2015-03-08.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation

class ListManager {
    func findAListOfFeaturedBusinesses(callback: ([BusinessEntity]) -> Void) {
        var query = FeaturedEntity.query()
        query.includeKey("business")
        query.includeKey("business.location")
        
        query.findObjectsInBackgroundWithBlock {(objects: [AnyObject]!, error: NSError!) -> Void in
            //TODO: handle NSError
            var featureds = objects as [FeaturedEntity]
//            var businesses = featureds.map( {$0.business!} )
            var businesses = [BusinessEntity]()
            for item in featureds {
                businesses.append(item.business)
            }
            callback(businesses)
        }
    }
}