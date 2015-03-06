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
    var address: [String] {
        get {
            return objectForKey("address") as [String]
        }
        set {
            setObject(newValue, forKey: "address")
        }
    }
    
    // Address for this business formatted for display. Includes all address fields, cross streets and city, state_code, etc.
    var displayAddress: [String] {
        get {
            return objectForKey("display_address") as [String]
        }
    }
    
    // City for this business
    var city: String {
        get {
            return objectForKey("city") as String
        }
        set {
            setObject(newValue, forKey: "city")
        }
    }
    
    // ISO 3166-2 state code for this business
    var stateCode: String {
        get {
            return objectForKey("state_code") as String
        }
        set {
            setObject(newValue, forKey: "state_code")
        }
    }
    
    // Postal code for this business
    var postalCode: String {
        get {
            return objectForKey("postal_code") as String
        }
        set {
            setObject(newValue, forKey: "postal_code")
        }
    }
    
    // ISO 3166-1 country code for this business
    var countryCode: String {
        get {
            return objectForKey("country_code") as String
        }
        set {
            setObject(newValue, forKey: "country_code")
        }
    }
    
    // Cross streets for this business
    var crossStreets: String {
        get {
            return objectForKey("cross_streets") as String
        }
        set {
            setObject(newValue, forKey: "cross_streets")
        }
    }
    
    // List that provides neighborhood(s) information for business
    var neighborhoods: [String] {
        get {
            return objectForKey("neighborhoods") as [String]
        }
        set {
            setObject(newValue, forKey: "neighborhoods")
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
