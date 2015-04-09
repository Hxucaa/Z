//
//  IFeaturedListViewModel.swift
//  XListing
//
//  Created by Lance Zhu on 2015-04-08.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import SwiftTask
import ReactKit

public protocol IFeaturedListViewModel {
    var dynamicArray: DynamicArray { get }
    func requestAllBusinesses() -> Task<Int, Void, NSError>
}