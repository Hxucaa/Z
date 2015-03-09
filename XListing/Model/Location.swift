//
//  Location.swift
//  XListing
//
//  Created by Lance Zhu on 2015-03-02.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation

class Location : PFObject, PFSubclassing {
    
    // Address for this business. Only includes address fields.
    var address: [String]? {
        get {
            return self["address"] as? [String]
        }
        set {
            self["address"] = newValue
        }
    }
    
    // Address for this business formatted for display. Includes all address fields, cross streets and city, state_code, etc.
    var displayAddress: [String]? {
        get {
            return self["display_address"] as? [String]
        }
    }
    
    // City for this business
    var city: String? {
        get {
            return self["city"] as? String
        }
        set {
            self["city"] = newValue
        }
    }
    
    // ISO 3166-2 state code for this business
    var stateCode: String? {
        get {
            return self["state_code"] as? String
        }
        set {
            self["state_code"] = newValue
        }
    }
    
    // Postal code for this business
    var postalCode: String? {
        get {
            return self["postal_code"] as? String
        }
        set {
            self["postal_code"] = newValue
        }
    }
    
    // ISO 3166-1 country code for this business
    var countryCode: String? {
        get {
            return self["country_code"] as? String
        }
        set {
            self["country_code"] = newValue
        }
    }
    
    // Cross streets for this business
    var crossStreets: String? {
        get {
            return self["cross_streets"] as? String
        }
        set {
            self["cross_streets"] = newValue
        }
    }
    
    // List that provides neighborhood(s) information for business
    var neighborhoods: [String]? {
        get {
            return self["neighborhoods"] as? [String]
        }
        set {
            self["neighborhoods"] = newValue
        }
    }
    
    
    // Class Name
    class func parseClassName() -> String! {
        return "Location"
    }
    
    // MARK: Constrcutros
    override class func initialize() {
        var onceToken : dispatch_once_t = 0;
        dispatch_once(&onceToken) {
            self.registerSubclass()
        }
    }
}
