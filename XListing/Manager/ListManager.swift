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
        .then { (objects: [AnyObject]?, errorInfo) -> [FeaturedEntity]? in
            if let errorInfo = errorInfo {
                return nil
            }
            else {
                return objects as? [FeaturedEntity]
            }
        }
        .success { (objects: [FeaturedEntity]?) -> [BusinessEntity] in
            var businesses = [BusinessEntity]()
            if let featureds = objects {
                businesses = featureds.map( {$0.business!} )
            }
            
            return businesses
        }
        
        return task
    }
}