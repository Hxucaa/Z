//
//  ListManager.swift
//  XListing
//
//  Created by Lance Zhu on 2015-03-08.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation

class ListManager {
    func findAListOfFeaturedBusinesses(callback: ([Business]) -> Void) {
        var query = Featured.query()
        query.includeKey("business")
        query.includeKey("business.location")
        
        query.findObjectsInBackgroundWithBlock {(objects: [AnyObject]!, error: NSError!) -> Void in
            //TODO: handle NSError
            var featureds = objects as [Featured]
//            var businesses = featureds.map( {$0.business!} )
            var businesses = [Business]()
            for item in featureds {
                if let b = item.business {
                    businesses.append(b)
                }
            }
            callback(businesses)
        }
    }
}