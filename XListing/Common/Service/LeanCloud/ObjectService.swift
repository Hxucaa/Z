//
//  ObjectService.swift
//  XListing
//
//  Created by Lance Zhu on 2015-04-18.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import SwiftTask
import AVOSCloud

public class ObjectService : IObjectService {
    
    public func save<T: AVObject>(obj: T) -> Task<Int, Bool, NSError> {
        return Task<Int, Bool, NSError> { (fulfill, reject) -> Void in
            obj.saveInBackgroundWithBlock { (success, error) -> Void in
                if success {
                    fulfill(success)
                }
                else {
                    reject(error!)
                }
            }
        }
    }
    
    public func getFirst(var query: AVQuery?) -> Task<Int, AVObject, NSError> {
        return Task<Int, AVObject, NSError> { progress, fulfill, reject, configure in
            query!.getFirstObjectInBackgroundWithBlock { (object, error) -> Void in
                if error == nil {
                    fulfill(object!)
                }
                else {
                    reject(error!)
                }
            }
        }
    }
    
    public func findBy(var query: AVQuery?) -> Task<Int, [AVObject], NSError> {
        let task = Task<Int, [AnyObject], NSError> { progress, fulfill, reject, configure in
            query!.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
                if error == nil {
                    fulfill(objects!)
                }
                else {
                    reject(error!)
                }
            }
        }
        .success { objects -> [AVObject] in
            let businesses = objects as! [AVObject]
            
            return businesses
        }
        
        return task
    }
}