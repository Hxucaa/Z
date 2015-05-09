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

public protocol INearbyViewModel {
    var businessVMArr: DynamicArray { get }
    func getBusiness()
    func getCurrentLocation() -> Task<Int, CLLocation, NSError>
    func pushDetailModule(businessViewModel: BusinessViewModel)
}