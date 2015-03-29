//
//  IFeaturedListPresenter.swift
//  XListing
//
//  Created by Lance Zhu on 2015-03-24.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import SwiftTask

public protocol IFeaturedListPresenter {
    /// This function returns a Task which contains an array of Display Data of Featured List.
    ///
    /// :returns: a generic Task containing an array of FeaturedListDisplayData.
    func getList() -> Task<Int, [FeaturedListDisplayData], NSError>
}