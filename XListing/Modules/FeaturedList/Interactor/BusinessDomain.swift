//
//  BusinessDomain.swift
//  XListing
//
//  Created by Lance Zhu on 2015-03-08.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation

struct BusinessDomain : Printable {
    var nameSChinese: String?
    var nameTChinese: String?
    var nameEnglish: String?
    var isClaimed: Bool?
    var isClosed: Bool?
    var phone: String?
    var url: String?
    var mobileUrl: String?
    var uid: String?
    var imageUrl: String?
    var reviewCount: Int?
    var rating: Double?
    var unit: String?
    var address: String?
    var district: String?
    var city: String?
    var state: String?
    var country: String?
    var postalCode: String?
    var crossStreets: String?
    var neighborhoods: [String]?
    var distance: Double?
    
    init(_ business: BusinessEntity, distance: Double?) {
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
    
    var description: String {
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