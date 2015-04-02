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
        
        :params: keyValuePair A tuple which comprises of a String of the name of the key and the value.
        :returns: a Task containing the result Entity in optional.
    */
    public func getFirst(keyValuePair: (key: String, value: AnyObject)...) -> Task<Int, T, NSError> {
        let task = Task<Int, PFObject, NSError> { progress, fulfill, reject, configure in
            let query = T.query()
            for (key, value) in keyValuePair {
                query.whereKey(key, equalTo: value)
            }
            query.getFirstObjectInBackgroundWithBlock { (object, error) -> Void in
                if error == nil {
                    fulfill(object)
                }
                else {
                    reject(error)
                }
            }
        }
        .success { object -> T in
            return object as T
        }
        
        return task
    }
    
    /**
        Finds the entities that match the value for the key.
        
        :params: keyValuePair A tuple which comprises of a String of the name of the key and the value.
        
        :returns: A Task which contains an optional of the entity.
    */
    public func find(keyValuePair: (key: String, value: AnyObject)...) -> Task<Int, [T], NSError> {
        let findTask = find(keyValuePair)
        
        return findTask
    }
    
    private func find(keyValuePair: [(key: String, value: AnyObject)]) -> Task<Int, [T], NSError> {
        
        let task = Task<Int, [AnyObject], NSError> { progress, fulfill, reject, configure in
            let query = T.query()
            for (key, value) in keyValuePair {
                query.whereKey(key, equalTo: value)
            }
            query.findObjectsInBackgroundWithBlock { (objects: [AnyObject]!, error: NSError!) -> Void in
                if error == nil {
                    fulfill(objects)
                }
                else {
                    reject(error)
                }
            }
        }
        .success { objects -> [T] in
            return objects as [T]
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