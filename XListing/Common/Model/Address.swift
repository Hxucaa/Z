//
//  Address.swift
//  XListing
//
//  Created by Lance Zhu on 2016-01-17.
//  Copyright © 2016 ZenChat. All rights reserved.
//

import Foundation
import AVOSCloud

public final class Address: AVObject, AVSubclassing {
    
    public struct Property {
        static let street = "street"
        static let regionCode = "regionCode"
        static let postalCode = "postalCode"
        static let geoLocation = "geoLocation"
        static let fullAddress = "fullAddress"
        static let isActive = "isActive"
    }
    
    public override init() {
        super.init()
    }
    
    
    // Class Name
    public class func parseClassName() -> String {
        return "Address"
    }
    
    // MARK: Constructors
    public override class func registerSubclass() {
        var onceToken: dispatch_once_t = 0
        dispatch_once(&onceToken) {
            super.registerSubclass()
        }
    }
    
    @NSManaged public var street: String
    
    @NSManaged private var regionCode: String
    
    public var province: Province {
        return Province(code: regionCode)
    }
    
    public var city: City {
        return City(code: regionCode)
    }
    
    public var district: District {
        return District(code: regionCode)
    }
//
//    public var region: Region {
//        get {
//            return Region(code: regionCode)
//        }
//        set {
//            regionCode = newValue.code
//        }
//    }
    
    
    
    @NSManaged public var postalCode: String?
    
    public var geoLocation: Geolocation {
        get {
            let geopoint = self[Property.geoLocation] as! AVGeoPoint
            return Geolocation(latitude: geopoint.latitude, longitude: geopoint.longitude)
        }
        set {
            self[Property.geoLocation] = AVGeoPoint(latitude: newValue.latitude, longitude: newValue.longitude)
        }
    }
    
    @NSManaged public var fullAddress: String
    
    public var isActive: Activation {
        get {
            return Activation(self[Property.isActive] as! Bool)
        }
        set {
            self[Property.isActive] = newValue.boolValue
        }
    }
    
}