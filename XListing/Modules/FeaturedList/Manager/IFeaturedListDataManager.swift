//
//  IFeaturedListDataManager.swift
//  XListing
//
//  Created by Lance Zhu on 2015-03-24.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import SwiftTask

public protocol IFeaturedListDataManager {
    ///
    /// This function find a list of featured businesses and returns an array of Business Entities.
    ///
    /// :returns: a generic Task containing an array of Business Entities.
    func findAListOfFeaturedBusinesses() -> Task<Int, [BusinessEntity], NSError>
}