//
//  INearbyViewModel.swift
//  XListing
//
//  Created by Lance Zhu on 2015-04-12.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import ReactKit
import SwiftTask

public protocol INearbyViewModel : class {
    var businessDynamicArr: DynamicArray { get }
    func getCurrentLocation() -> Stream<CLLocation>
    func getBusiness() -> Stream<Void>
    func pushDetailModule(section: Int)
}