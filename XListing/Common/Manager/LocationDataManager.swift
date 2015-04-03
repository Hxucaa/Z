//
//  LocationManager.swift
//  XListing
//
//  Created by Lance Zhu on 2015-03-22.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import SwiftTask

public class LocationDataManager {
    
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
    
    /**
        This function translate physical address to geolocation coordinates.
        
        :params: address A String of the address.
        :returns: a Task containing a GeoPointEntity which contains the location data.
    */
    public func forwardGeocoding(address: String) -> Task<Int, GeoPointEntity, NSError> {
        let task =
            Task<Int, [AnyObject], NSError> { progress, fulfill, reject, configure in
                CLGeocoder().geocodeAddressString(address, completionHandler: { (placemarks: [AnyObject]!, error: NSError!) -> Void in
                    if error == nil && placemarks.count > 0 {
                        fulfill(placemarks)
                    }
                    else {
                        reject(error)
                    }
                })
            }
            .success { (placemarks: [AnyObject]) -> GeoPointEntity in
                // convert to GeoPointEntity
                let placemark = placemarks[0] as CLPlacemark
                let location = placemark.location
                let geopoint = GeoPointEntity(location)
                
                return geopoint
            }
        return task
    }
}