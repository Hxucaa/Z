//
//  FeaturedBusinessDataManager.swift
//  XListing
//
//  Created by Lance Zhu on 2015-04-02.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import SwiftTask

public class BusinessDataManager {
    /**
        This function saves the BusinessEntity and returns true if success otherwise false.
        
        :params: object A BusinessEntity.
        :returns: a generic Task containing a boolean value.
    */
    public func save(object: BusinessEntity) -> Task<Int, Bool, NSError> {
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
        This function finds the BusinessEntity based on the query.

        :params: query A PFQuery.
        :returns: a Task containing the result Entity in optional.
    */
    public func getFirst(var _ query: PFQuery = BusinessEntity.query()) -> Task<Int, BusinessEntity?, NSError> {
        let task = Task<Int, PFObject, NSError> { progress, fulfill, reject, configure in
            self.enhanceQuery(&query)
            query.getFirstObjectInBackgroundWithBlock { (object, error) -> Void in
                if error == nil {
                    fulfill(object)
                }
                else {
                    reject(error)
                }
            }
            }
            .success { object -> BusinessEntity? in
                return object as? BusinessEntity
        }

        return task
    }
    
    /**
        Finds the BusinessEntities based on the query.
        
        :params: query A PFQuery.
        :returns: A Task which contains an array of BusinessEntity.
    */
    public func findBy(var _ query: PFQuery = BusinessEntity.query()) -> Task<Int, [BusinessEntity], NSError> {
        
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
            .success { (objects: [AnyObject]) -> [BusinessEntity] in
                let businesses = objects as [BusinessEntity]
                
                return businesses
        }
        
        return task
    }
    
    private func enhanceQuery(inout query: PFQuery) {
        query.includeKey("location")
    }
}