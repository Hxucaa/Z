//
//  BusinessDomain.swift
//  XListing
//
//  Created by Lance Zhu on 2015-03-08.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation

public struct BusinessDomain : Printable {
    public var nameSChinese: String?
    public var nameTChinese: String?
    public var nameEnglish: String?
    public var isClaimed: Bool?
    public var isClosed: Bool?
    public var phone: String?
    public var url: String?
    public var mobileUrl: String?
    public var uid: String?
    public var imageUrl: String?
    public var reviewCount: Int?
    public var rating: Double?
    public var unit: String?
    public var address: String?
    public var district: String?
    public var city: String?
    public var state: String?
    public var country: String?
    public var postalCode: String?
    public var crossStreets: String?
    public var neighborhoods: [String]?
    public var distance: Double?
    
    public init(_ business: BusinessEntity, distance: Double?) {
        nameSChinese = business.nameSChinese
        nameTChinese = business.nameTChinese
        nameEnglish = business.nameEnglish
        isClaimed = business.isClaimed
        isClosed = business.isClosed
        phone = business.phone
        url = business.url
        mobileUrl = business.mobileUrl
        uid = business.uid
        imageUrl = business.imageUrl
        reviewCount = business.reviewCount
        rating = business.rating
        if let loc = business.location {
            unit = loc.unit
            address = loc.address
            district = loc.district
            city = loc.city
            state = loc.state
            country = loc.country
            postalCode = loc.postalCode
            crossStreets = loc.crossStreets
            neighborhoods = loc.neighborhoods
            self.distance = distance
        }
    }
    
    public var description: String {
        let bdMirror = reflect(self)
        var result = ""
        for var i = 0; i < bdMirror.count; i++ {
            let (propertyName, childMirror) = bdMirror[i]
            
            result += "\(propertyName): \(childMirror.value)\n"
        }
        result += "\n"
        return result
    }
}