//
//  Address.swift
//  XListing
//
//  Created by Lance Zhu on 2016-03-19.
//  Copyright © 2016 Lance Zhu. All rights reserved.
//

import Foundation

public struct Address : IModel {
    public let objectId: String
    public let updatedAt: NSDate
    public let createdAt: NSDate
    
    public let street: String
    public let district: District
    public let city: City
    public let province: Province
    public let postalCode: String?
    public let geoLocation: Geolocation
    public let fullAddress: String
    
//    public init(objectId: String, updatedAt: NSDate, createdAt: NSDate, street: String, district: District, city: City, province: Province, postalCode: String?, geoLocation: Geolocation, fullAddress: String) {
//        
//        self.street = street
//        self.district = district
//        self.city = city
//        self.province = province
//        self.postalCode = postalCode
//        self.geoLocation = geoLocation
//        self.fullAddress = fullAddress
//        
//        super.init(objectId: objectId, updatedAt: updatedAt, createdAt: createdAt)
//    }
}