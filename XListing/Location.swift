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
    @NSManaged var address: [String]
    
    // Address for this business formatted for display. Includes all address fields, cross streets and city, state_code, etc.
    @NSManaged var display_address: [String]
    
    // City for this business
    @NSManaged var city: String
    
    // ISO 3166-2 state code for this business
    @NSManaged var state_code: String
    
    // Postal code for this business
    @NSManaged var postal_code: String
    
    // ISO 3166-1 country code for this business
    @NSManaged var country_code: String
    
    // Cross streets for this business
    @NSManaged var cross_streets: String
    
    // List that provides neighborhood(s) information for business
    @NSManaged var neighborhoods: [String]
    
    
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
