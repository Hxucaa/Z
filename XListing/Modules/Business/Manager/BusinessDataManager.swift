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
}