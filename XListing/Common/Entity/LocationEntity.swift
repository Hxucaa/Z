//
//  Location.swift
//  XListing
//
//  Created by Lance Zhu on 2015-03-02.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation

public class LocationEntity: PFObject, PFSubclassing {
    
    public var completeAddress: String? {
        get {
            var addressString = ""
            if let address = address {
                addressString += "\(address) "
            }
            else {
                return nil
            }
            if let city = city {
                addressString += "\(city) "
            }
            else {
                return nil
            }
            if let state = state {
                addressString += "\(state) "
            }
            else {
                return nil
            }
            if let country = country {
                addressString += "\(country)"
            }
            else {
                return nil
            }
            return addressString
        }
    }
    
    public var unit: String? {
        get {
            return self["unit"] as? String
        }
        set {
            self["unit"] = newValue
        }
    }
    
    // Address for this business. Only includes address fields.
    public var address: String? {
        get {
            return self["address"] as? String
        }
        set {
            self["address"] = newValue
        }
    }
    
    public var district: String? {
        get {
            return self["district"] as? String
        }
        set {
            self["distrcit"] = newValue
        }
    }
    
    // Address for this business formatted for display. Includes all address fields, cross streets and city, state_code, etc.
//    var displayAddress: [String] {
//        get {
//            return self["display_address"] as [String]
//        }
//    }
    
    // City for this business
    public var city: String? {
        get {
            return self["city"] as? String
        }
        set {
            self["city"] = newValue
        }
    }
    
    public var state: String? {
        get {
            return self["state"] as? String
        }
        set {
            self["state"] = newValue
        }
    }
    
    public var country: String? {
        get {
            return self["country"] as? String
        }
        set {
            self["country"] = newValue
        }
    }
    
    // Postal code for this business
    public var postalCode: String? {
        get {
            return self["postal_code"] as? String
        }
        set {
            self["postal_code"] = newValue
        }
    }
    
    // Cross streets for this business
    public var crossStreets: String? {
        get {
            return self["cross_streets"] as? String
        }
        set {
            self["cross_streets"] = newValue
        }
    }
    
    // List that provides neighborhood(s) information for business
    public var neighborhoods: [String]? {
        get {
            return self["neighborhoods"] as? [String]
        }
        set {
            self["neighborhoods"] = newValue
        }
    }
    
    public var geopoint: GeoPointEntity? {
        get {
            if let gp = self["geopoint"] as? PFGeoPoint {
                return GeoPointEntity(gp)
            }
            else {
                return nil
            }
        }
        set {
            self["geopoint"] = newValue?.pfGeoPoint
        }
    }
    
    // Class Name
    public class func parseClassName() -> String! {
        return "Location"
    }
    
    // MARK: Constrcutros
    public override class func initialize() {
        var onceToken : dispatch_once_t = 0;
        dispatch_once(&onceToken) {
            self.registerSubclass()
        }
    }
}
