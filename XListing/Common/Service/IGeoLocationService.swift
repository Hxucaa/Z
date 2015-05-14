//
//  IGeoLocationService.swift
//  XListing
//
//  Created by Lance Zhu on 2015-05-05.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import SwiftTask

public protocol IGeoLocationService : class {
    var defaultGeoPoint: PFGeoPoint { get }
    func getCurrentLocation() -> Task<Int, CLLocation, NSError>
    func getCurrentGeoPoint() -> Task<Int, PFGeoPoint, NSError>
}