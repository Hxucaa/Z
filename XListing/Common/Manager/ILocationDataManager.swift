//
//  ILocationDataManager.swift
//  XListing
//
//  Created by Lance Zhu on 2015-03-24.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import SwiftTask

public protocol ILocationDataManager {
    ///
    /// This function asks for the current location. Returns a Task which contains a GeoPointEntity of current location.
    ///
    /// :returns: a generic Task containing a GeoPointEntity representing the current location.
    func getCurrentGeoPoint() -> Task<Int, GeoPointEntity, NSError>
    
    /**
        This function translate physical address to geolocation coordinates.
    
        :returns: a Task containing a GeoPointEntity which contains the location data.
    */
    func forwardGeocoding(address: String) -> Task<Int, GeoPointEntity, NSError>
}