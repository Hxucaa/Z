//
//  GeolocationDataManager.swift
//  XListing
//
//  Created by Lance Zhu on 2015-04-03.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import SwiftTask

public class GeolocationDataManager : IGeolocationDataManager {
    
    ///
    /// This function asks for the current location. Returns a Task which contains a GeoPointEntity of current location.
    ///
    /// :returns: a generic Task containing a GeoPointEntity representing the current location.
    public func getCurrentGeoPoint() -> Task<Int, GeoPointEntity, NSError> {
        let task = Task<Int, GeoPointEntity, NSError> { progress, fulfill, reject, configure in
            // asks device for current location
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
}