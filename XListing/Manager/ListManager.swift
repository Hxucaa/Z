//
//  ListManager.swift
//  XListing
//
//  Created by Lance Zhu on 2015-03-08.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import SwiftTask

class ListManager {
//    func findAListOfFeaturedBusinesses(callback: (businesses: [BusinessEntity], error: NSError?) -> Void) {
//        var query = FeaturedEntity.query()
//        query.includeKey("business")
//        query.includeKey("business.location")
//
//        query.findObjectsInBackgroundWithBlock {(objects: [AnyObject]!, error: NSError!) -> Void in
//            //TODO: handle NSError
//            var featureds = objects as [FeaturedEntity]
//            var businesses = featureds.map( {$0.business} )
//            callback(businesses: businesses, error: error)
//        }
//    }
    
    func findAListOfFeaturedBusinesses() -> Task<Int, [BusinessEntity], NSError> {
        
        let task = Task<Int, [AnyObject], NSError> { progress, fulfill, reject, configure in
            var query = FeaturedEntity.query()
            query.includeKey("business")
            query.includeKey("business.location")
            
            query.findObjectsInBackgroundWithBlock {(objects: [AnyObject]!, error: NSError!) in
                if error == nil {
                    fulfill(objects)
                }
                else {
                    reject(error)
                }
            }
        }
        
        let resultTask = task
            .success { (objects: [AnyObject]) -> [BusinessEntity] in
                var featureds = objects as [FeaturedEntity]
                var businesses = featureds.map( {$0.business} )
                
                return businesses
            }
        return resultTask
    }
}