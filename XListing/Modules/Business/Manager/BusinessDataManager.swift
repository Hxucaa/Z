//
//  BusinessDataManager.swift
//  XListing
//
//  Created by Lance Zhu on 2015-03-31.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import SwiftTask

public class BusinessDataManager : IBusinessDataManager {
    public func save(business: BusinessEntity) -> Task<Int, Bool, NSError> {
        let task = Task<Int, Bool, NSError> { progress, fulfill, reject, configure in
            business.saveInBackgroundWithBlock { (success: Bool, error: NSError!) -> Void in
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
    
    public func findOne<T: AnyObject>(key: String, value: T) -> Task<Int, BusinessEntity?, NSError> {
        let task =
            Task<Int, [AnyObject], NSError> { progress, fulfill, reject, configure in
                let query = BusinessEntity.query()
                query.whereKey(key, equalTo: value)
                
                query.findObjectsInBackgroundWithBlock { (objects: [AnyObject]!, error: NSError!) -> Void in
                    if error == nil {
                        let count = objects.count
                        if count > 1 {
                            reject(NSError(domain: "There are \(count) business(es) sharing the same value: \(value) for key: \(key)", code: 001, userInfo: nil))
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
            .success { business -> BusinessEntity? in
                return (business as? [BusinessEntity])?.first
            }
        
        return task
    }
}