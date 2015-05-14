//
//  GeoLocationService.swift
//  XListing
//
//  Created by Lance Zhu on 2015-05-05.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import SwiftTask
import MapKit

public class GeoLocationService : IGeoLocationService {
    
    
    public let defaultGeoPoint = PFGeoPoint(latitude: 49.27623, longitude: -123.12941)
    
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
    
    public func getCurrentGeoPoint() -> Task<Int, PFGeoPoint, NSError> {
        let task = Task<Int, PFGeoPoint, NSError> { [unowned self] progress, fulfill, reject, configure in
            // get current location
            PFGeoPoint.geoPointForCurrentLocationInBackground({ (geopoint, error) -> Void in
                if error == nil {
                    
                    fulfill(geopoint!)
                }
                else {
                    reject(error!)
                }
            })
        }
        
        return task
    }
}