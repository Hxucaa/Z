//
//  BaseDataManager.swift
//  XListing
//
//  Created by Lance Zhu on 2015-04-01.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import SwiftTask

public class BaseDataManager<T: PFObject> {
    /**
        This function saves the PFObject and returns true if success otherwise false.
    
        :returns: a generic Task containing a boolean value.
    */
    public func save(pfobject: T) -> Task<Int, Bool, NSError> {
        let task = Task<Int, Bool, NSError> { progress, fulfill, reject, configure in
            pfobject.saveInBackgroundWithBlock { (success: Bool, error: NSError!) -> Void in
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
        This function finds the Entity based on the provided key value pair.
        
        :params: key A String of the column name.
        :params: value An Anyobject
        :returns: a Task containing the result Entity in optional.
    */
    public func findOne(keyValuePair: (key: String, value: AnyObject)...) -> Task<Int, T?, NSError> {
        let task =
            Task<Int, [AnyObject], NSError> { progress, fulfill, reject, configure in
                let query = T.query()
                for (key, value) in keyValuePair {
                    query.whereKey(key, equalTo: value)
                }
                query.findObjectsInBackgroundWithBlock { (objects: [AnyObject]!, error: NSError!) -> Void in
                    if error == nil {
                        let count = objects.count
                        if count > 1 {
                            reject(NSError(domain: "There are \(count) business(es) sharing the following: \(keyValuePair)", code: 001, userInfo: nil))
                        }
                        else {
                            fulfill(objects)
                        }
                        
                    }
                    else {
                        reject(error)
                    }
                }
            }
            .success { business -> T? in
                return (business as? [T])?.first
            }
        
        return task
    }
    
    /**
        Finds all of the Entity.
    
        :returns: a Task containing the array of the entities.
    */
    public func all() -> Task<Int, [T], NSError> {
        let task =
            Task<Int, [AnyObject], NSError> { progress, fulfill, reject, configure in
                let query = T.query()
                query.findObjectsInBackgroundWithBlock { (objects: [AnyObject]!, error: NSError!) -> Void in
                    if error == nil {
                        fulfill(objects)
                    }
                    else {
                        reject(error)
                    }
                }
            }
            .success { (objects: [AnyObject]) -> [T] in
                return objects as [T]
            }
        
        return task
    }
}