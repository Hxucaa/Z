//
//  IFeaturedListBusinessCell_StatsViewModel.swift
//  XListing
//
//  Created by Lance Zhu on 2015-09-15.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import ReactiveCocoa

public protocol IFeaturedListBusinessCell_StatsViewModel : class {
    var treatCount: PropertyOf<String> { get }
    var aaCount: PropertyOf<String> { get }
    var toGoCount: PropertyOf<String> { get }
}