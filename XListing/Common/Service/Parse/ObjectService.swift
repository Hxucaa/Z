//
//  ObjectService.swift
//  XListing
//
//  Created by Lance Zhu on 2015-04-18.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import SwiftTask

public class ObjectService : IObjectService {
    
    public func save(obj: PFObject) -> Task<Int, Bool, NSError> {
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
    
    public func getFirst(var query: PFQuery?) -> Task<Int, PFObject, NSError> {
        return Task<Int, PFObject, NSError> { progress, fulfill, reject, configure in
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
}