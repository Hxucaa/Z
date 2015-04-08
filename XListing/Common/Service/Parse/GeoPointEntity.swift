//
//  GeoPointEntity.swift
//  XListing
//
//  Created by Lance Zhu on 2015-03-22.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation

public class GeoPointEntity {
    private(set) var pfGeoPoint: PFGeoPoint
    
    public init(_ location: CLLocation) {
        pfGeoPoint = PFGeoPoint(location: location)
    }
    
    public init(latitude: Double, longitude: Double) {
        pfGeoPoint = PFGeoPoint(latitude: latitude, longitude: longitude)
    }
    
    public init?(_ geopoint: PFGeoPoint!) {
        pfGeoPoint = geopoint
    }
    
    public var longitude: Double {
        get {
            return pfGeoPoint.longitude
        }
        set {
            pfGeoPoint.longitude = newValue
        }
    }
    
    public var latitude: Double {
        get {
            return pfGeoPoint.latitude
        }
        set {
            pfGeoPoint.latitude = newValue
        }
    }
    
    public func distanceInKilometersTo(another: GeoPointEntity!) -> Double {
        return pfGeoPoint.distanceInKilometersTo(another.pfGeoPoint)
    }
    
    public func distanceInRadiansTo(another: GeoPointEntity!) -> Double {
        return pfGeoPoint.distanceInRadiansTo(another.pfGeoPoint)
    }
    
    public func distanceInMilesTo(another: GeoPointEntity!) -> Double {
        return pfGeoPoint.distanceInMilesTo(another.pfGeoPoint)
    }
    
}

extension GeoPointEntity {
    
    public class func geoPointForCurrentLocationInBackground(callback: (geopoint: GeoPointEntity!, error: NSError!) -> Void) -> Void {
        PFGeoPoint.geoPointForCurrentLocationInBackground { (gp: PFGeoPoint!, error: NSError!) -> Void in
            callback(geopoint: GeoPointEntity(gp), error: error)
        }
    }
}

extension GeoPointEntity : Printable {
    public var description: String {
        return self.pfGeoPoint.description
    }
}