//
//  IBusinessDataManager.swift
//  XListing
//
//  Created by Lance Zhu on 2015-03-31.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import SwiftTask

public protocol IBusinessDataManager {
    ///
    /// This function saves the business and returns true if success otherwise false.
    ///
    /// :returns: a generic Task containing a boolean value.
    func save(business: BusinessEntity) -> Task<Int, Bool, NSError>
}