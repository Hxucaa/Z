//
//  Geolocation.swift
//  XListing
//
//  Created by Lance Zhu on 2015-09-17.
//  Copyright (c) 2016 Lance Zhu. All rights reserved.
//

import Foundation
import MapKit

public struct Geolocation : CustomStringConvertible {
    
    /// Latitude of point in degrees.  Valid range (-90.0, 90.0).
    public var latitude: Double {
        willSet {
            assert(newValue >= -90.0 && newValue <= 90.0, "Latitude must be in range of (-90.0, 90.0)")
        }
    }
    /// Longitude of point in degrees.  Valid range (-180.0, 180.0).
    public var longitude: Double {
        willSet {
            assert(newValue >= -180.0 && newValue <= 180.0, "Longitude must be in range of (-90.0, 90.0)")
        }
    }
    
    public var cllocation: CLLocation {
        return CLLocation(latitude: latitude, longitude: longitude)
    }
    
    /**
    Initializes a new Geolocation struct for the given CLLocation, set to the location's coordinates.
    
    - parameter location: CLLocation object, with set latitude and longitude.
    */
    public init(location: CLLocation) {
        latitude = location.coordinate.latitude
        longitude = location.coordinate.longitude
    }
    
    /**
    Initializes a new Geolocation struct with the specified latitude and longitude.
    
    - parameter latitude:  Latitude of point in degrees.
    - parameter longitude: Longitude of point in degrees.
    */
    public init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
    
    public var description: String {
        return "\(latitude), \(longitude)"
    }
}