//
//  Business.swift
//  XListing
//
//  Created by Lance Zhu on 2015-04-06.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import Realm
import CoreLocation

public class Business: RLMObject {
    
    /**
    *  Parse fileds
    */
    public dynamic var objectId: String = ""
    public dynamic var remoteCreatedAt: NSTimeInterval = -1.0
    public dynamic var remoteUpdatedAt: NSTimeInterval = -1.0
    
    /**
    *  Business info
    */
    public dynamic var nameSChinese: String = ""
    public dynamic var nameTChinese: String = ""
    public dynamic var nameEnglish: String = ""
    public dynamic var isClaimed: Bool = false
    public dynamic var isClosed: Bool = false
    public dynamic var phone: String = ""
    public dynamic var url: String = ""
    public dynamic var mobileUrl: String = ""
    public dynamic var uid: String = ""
    public dynamic var imageUrl: String = ""
    public dynamic var reviewCount: Int = 0
    public dynamic var rating: Double = -1
    public dynamic var coverImageUrl: String = ""
    
    /**
    *  Featured
    */
    public dynamic var featured: Bool = false
    public dynamic var timeStart: NSTimeInterval = -1.0
    public dynamic var timeEnd: NSTimeInterval = -1.0
    
    /**
    *  Location
    */
    public dynamic var unit: String = ""
    public dynamic var address: String = ""
    public dynamic var district: String = ""
    public dynamic var city: String = ""
    public dynamic var state: String = ""
    public dynamic var country: String = ""
    public dynamic var postalCode: String = ""
    public dynamic var crossStreets: String = ""
    public dynamic var latitude: Double = -360
    public dynamic var longitude: Double = -360
    
    /**
    *  Statistics
    */
    public dynamic var wantToGoCounter: Int = 0
    
    
    public override class func primaryKey() -> String! {
        return "objectId"
    }
    
    public override class func ignoredProperties() -> [AnyObject] {
        let propertiesToIgnore = []
        return propertiesToIgnore as [AnyObject]
    }
    
    public override class func indexedProperties() -> [AnyObject] {
        let propertiesToIndex = ["nameSChinese"]
        return propertiesToIndex
    }
}

extension Business {
    
    /// Get complete address of the business
    public var completeAddress: String? {
        get {
            if !address.isEmpty && !city.isEmpty && !state.isEmpty && !country.isEmpty {
                return "\(address) \(city) \(state) \(country)"
            }
            else {
                return nil
            }
        }
    }
    
    public var cllocation: CLLocation {
        get {
            return CLLocation(latitude: latitude, longitude: longitude)
        }
    }
    
    public func distanceToLocation(another: CLLocation) -> Double {
        return cllocation.distanceFromLocation(another)
    }
}