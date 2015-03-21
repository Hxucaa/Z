//
//  FeaturedListDisplayData.swift
//  XListing
//
//  Created by Lance Zhu on 2015-03-09.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation

struct FeaturedListDisplayData : Printable {
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
//    var displayPhone: String
    var reviewCount: Int?
//    var distance: Double?
    var rating: Double?
    var unit: String?
    var address: String?
    var district: String?
//    var displayAddress: [String]
    var city: String?
    var state: String?
    var country: String?
    var postalCode: String?
    var crossStreets: String?
    var neighborhoods: [String]?
    
    init(businessDomain: BusinessDomain) {
        nameSChinese = businessDomain.nameSChinese
        nameTChinese = businessDomain.nameTChinese
        nameEnglish = businessDomain.nameEnglish
        isClaimed = businessDomain.isClaimed
        isClosed = businessDomain.isClosed
        phone = businessDomain.phone
        url = businessDomain.url
        mobileUrl = businessDomain.mobileUrl
        uid = businessDomain.uid
        imageUrl = businessDomain.imageUrl
//        displayPhone = businessDomain.displayPhone
        reviewCount = businessDomain.reviewCount
//        distance = businessDomain.distance
        rating = businessDomain.rating
        unit = businessDomain.unit
        address = businessDomain.address
        district = businessDomain.district
//        displayAddress = businessDomain.displayAddress
        city = businessDomain.city
        state = businessDomain.state
        country = businessDomain.country
        postalCode = businessDomain.postalCode
        crossStreets = businessDomain.crossStreets
        neighborhoods = businessDomain.neighborhoods
    }
    
    var description: String {
        let bdMirror = reflect(self)
        var result = ""
        for var i = 0; i < bdMirror.count; i++ {
            let (propertyName, childMirror) = bdMirror[i]
            
            result += "\(propertyName): \(childMirror.value)\n"
        }
        return result
    }
}