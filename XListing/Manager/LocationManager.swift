//
//  LocationManager.swift
//  XListing
//
//  Created by Lance Zhu on 2015-03-22.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import SwiftTask

class LocationManager {
    ///
    /// @abstract Current location.
    ///
    func getCurrentGeoPoint() -> Task<Int, GeoPointEntity, NSError> {
        let task = Task<Int, GeoPointEntity, NSError> { progress, fulfill, reject, configure in
            GeoPointEntity.geoPointForCurrentLocationInBackground({ (geopoint, error) -> Void in
                if error == nil {
                    fulfill(geopoint)
                }
                else {
                    reject(error)
                }
            })
        }
        
        return task
    }
    
    func calDistanceInKilometersFromCurrentLocationTo(another: GeoPointEntity!) -> Task<Int, Double, NSError> {
        let task = getCurrentGeoPoint().success { (current: GeoPointEntity) -> Double in
            return current.distanceInKilometersTo(another)
        }
        
        return task
    }
}