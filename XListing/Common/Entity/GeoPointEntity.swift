//
//  GeoPointEntity.swift
//  XListing
//
//  Created by Lance Zhu on 2015-03-22.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation

class GeoPointEntity {
    private(set) var pfGeoPoint: PFGeoPoint
    
    init(_ location: CLLocation) {
        pfGeoPoint = PFGeoPoint(location: location)
    }
    
    init(latitude: Double, longitude: Double) {
        pfGeoPoint = PFGeoPoint(latitude: latitude, longitude: longitude)
    }
    
    init?(_ geopoint: PFGeoPoint!) {
        pfGeoPoint = geopoint
    }
    
    var longitude: Double {
        get {
            return pfGeoPoint.longitude
        }
        set {
            pfGeoPoint.longitude = newValue
        }
    }
    
    var latitude: Double {
        get {
            return pfGeoPoint.latitude
        }
        set {
            pfGeoPoint.latitude = newValue
        }
    }
    
    func distanceInKilometersTo(another: GeoPointEntity!) -> Double {
        return pfGeoPoint.distanceInKilometersTo(another.pfGeoPoint)
    }
    
    func distanceInRadiansTo(another: GeoPointEntity!) -> Double {
        return pfGeoPoint.distanceInRadiansTo(another.pfGeoPoint)
    }
    
    func distanceInMilesTo(another: GeoPointEntity!) -> Double {
        return pfGeoPoint.distanceInMilesTo(another.pfGeoPoint)
    }
    
}

extension GeoPointEntity {
    
    class func geoPointForCurrentLocationInBackground(callback: (geopoint: GeoPointEntity!, error: NSError!) -> Void) -> Void {
        PFGeoPoint.geoPointForCurrentLocationInBackground { (gp: PFGeoPoint!, error: NSError!) -> Void in
            callback(geopoint: GeoPointEntity(gp), error: error)
        }
    }
}

extension GeoPointEntity : Printable {
    var description: String {
        return self.pfGeoPoint.description
    }
}