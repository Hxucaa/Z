//
//  LocationManager.swift
//  XListing
//
//  Created by Lance Zhu on 2015-03-22.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import SwiftTask

public class LocationDataManager : ILocationDataManager {
    
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