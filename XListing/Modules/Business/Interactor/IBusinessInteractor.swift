//
//  IBusinessInteractor.swift
//  XListing
//
//  Created by Lance Zhu on 2015-03-31.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import SwiftTask

public protocol IBusinessInteractor {
    /// This function returns a Task which contains result of saving Business to the backend.
    ///
    /// :returns: a generic Task containing the result of saving BusinessEntity.
    ///
    func saveBusiness(business: BusinessDomain) -> Task<Int, Bool, NSError>
    func findBusinessBy(query: PFQuery) -> Task<Int, [BusinessDomain], NSError>
    func getFeaturedBusiness() -> Task<Int, [BusinessDomain], NSError>
}