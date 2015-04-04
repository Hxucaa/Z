//
//  IGeolocationDataManager.swift
//  XListing
//
//  Created by Lance Zhu on 2015-04-03.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import SwiftTask

public protocol IGeolocationDataManager {
    func getCurrentGeoPoint() -> Task<Int, GeoPointEntity, NSError>
}