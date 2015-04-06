//
//  Business.swift
//  XListing
//
//  Created by Lance Zhu on 2015-04-06.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import Realm

public class Business: RLMObject {
    /**
    *  Business info
    */
    public dynamic var nameSChinese: String?
    public dynamic var nameTChinese: String?
    public dynamic var nameEnglish: String?
    public dynamic var isClaimed: Bool = false
    public dynamic var isClosed: Bool = false
    public dynamic var phone: String?
    public dynamic var url: String?
    public dynamic var mobileUrl: String?
    public dynamic var uid: String?
    public dynamic var imageUrl: String?
    public dynamic var reviewCount: Int = 0
    public dynamic var rating: Double = -1
    public dynamic var categories: [String] = []
    
    /**
    *  Featured
    */
    public dynamic var featured: Bool = false
    public dynamic var timeStart: NSDate?  //TODO: convert to NSInterval
    public dynamic var timeEnd: NSDate?    //TODO: convert to NSInterval
    
    /**
    *  Location
    */
    public dynamic var unit: String?
    public dynamic var address: String?
    public dynamic var district: String?
    public dynamic var city: String?
    public dynamic var state: String?
    public dynamic var country: String?
    public dynamic var postalCode: String?
    public dynamic var crossStreets: String?
    public dynamic var neighborhoods: [String]?
    //    var geopoint: GeoPoint

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
}