//
//  GeoLocationService.swift
//  XListing
//
//  Created by Lance Zhu on 2015-05-05.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import SwiftTask

public class GeoLocationService : IGeoLocationService {
    public func getCurrentLocation() -> Task<Int, CLLocation, NSError> {
        let task = Task<Int, CLLocation, NSError> { [unowned self] progress, fulfill, reject, configure in
            // get current location
            PFGeoPoint.geoPointForCurrentLocationInBackground({ (geopoint, error) -> Void in
                if error == nil {
                    let t = geopoint!
                    fulfill(CLLocation(latitude: t.latitude, longitude: t.longitude))
                }
                else {
                    reject(error!)
                }
            })
        }
        
        return task
    }
}