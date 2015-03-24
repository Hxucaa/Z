//
//  IFeaturedListInteractor.swift
//  XListing
//
//  Created by Lance Zhu on 2015-03-24.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import SwiftTask

protocol IFeaturedListInteractor {
    
    /// This function returns a Task which contains an array of Business Domain Model.
    ///
    /// :returns: a generic Task containing an array of Business Domain Model.
    ///
    func getFeaturedList() -> Task<Int, [BusinessDomain], NSError>
}