//
//  AddressDAO.swift
//  XListing
//
//  Created by Lance Zhu on 2016-01-17.
//  Copyright © 2016 Lance Zhu. All rights reserved.
//

import Foundation
import AVOSCloud

internal final class AddressDAO: AVObject, AVSubclassing {
    
    internal struct Property {
        static let street = "street"
        static let regionCode = "regionCode"
        static let postalCode = "postalCode"
        static let geoLocation = "geoLocation"
        static let fullAddress = "fullAddress"
        static let isActive = "isActive"
    }
    
    internal override init() {
        super.init()
    }
    
    
    // Class Name
    internal class func parseClassName() -> String {
        return "Address"
    }
    
    // MARK: Constructors
    internal override class func registerSubclass() {
        var onceToken: dispatch_once_t = 0
        dispatch_once(&onceToken) {
            super.registerSubclass()
        }
    }
    
    @NSManaged internal var street: String
    @NSManaged internal var regionCode: String
    @NSManaged internal var postalCode: String?
    @NSManaged internal var geoLocation: AVGeoPoint
    @NSManaged internal var fullAddress: String
    
}

extension AddressDAO {
    static var typedQuery: TypedAVQuery<AddressDAO> {
        return TypedAVQuery<AddressDAO>(query: AddressDAO.query())
    }
}
