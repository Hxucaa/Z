//
//  FeaturedBusinessDataManager.swift
//  XListing
//
//  Created by Lance Zhu on 2015-04-02.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import SwiftTask

public class FeaturedBusinessDataManager {
    /**
        This function saves the FeaturedEntity and returns true if success otherwise false.
        
        :params: object A FeaturedEntity.
        :returns: a generic Task containing a boolean value.
    */
    public func save(object: FeaturedEntity) -> Task<Int, Bool, NSError> {
        let task = Task<Int, Bool, NSError> { progress, fulfill, reject, configure in
            object.saveInBackgroundWithBlock { (success: Bool, error: NSError!) -> Void in
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
    
    /**
        Finds the FeaturedEntities based on the query.
        
        :params: query A PFQuery.
        :returns: A Task which contains an optional of the entity.
    */
    public func findBy(var _ query: PFQuery = FeaturedEntity.query()) -> Task<Int, [BusinessEntity], NSError> {
        
        let task = Task<Int, [AnyObject], NSError> { progress, fulfill, reject, configure in
            self.enhanceQuery(&query)
            query.findObjectsInBackgroundWithBlock { (objects: [AnyObject]!, error: NSError!) -> Void in
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
    
    private func enhanceQuery(inout query: PFQuery) {
        query.includeKey("business")
        query.includeKey("business.location")
    }
}