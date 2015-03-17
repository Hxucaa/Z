//
//  FeaturedListDisplayData.swift
//  XListing
//
//  Created by Lance Zhu on 2015-03-09.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation

struct FeaturedListDisplayData : Printable {
    var isClaimed: Bool?
    var isClosed: Bool?
    var name: String?
    var imageUrl: String?
    var url: String?
    var mobileUrl: String?
    var phone: String?
    var displayPhone: String?
    var reviewCount: Int?
//    var distance: Double?
    var rating: Double?
    var address: [String]?
//    var displayAddress: [String]
    var city: String
    var stateCode: String
    var postalCode: String
    var countryCode: String
    var crossStreets: String?
    var neighborhoods: [String]
    
    init(businessDomain: BusinessDomain) {
        isClaimed = businessDomain.isClaimed
        isClosed = businessDomain.isClosed
        name = businessDomain.name
        imageUrl = businessDomain.imageUrl
        url = businessDomain.url
        mobileUrl = businessDomain.mobileUrl
        phone = businessDomain.phone
        displayPhone = businessDomain.displayPhone
        reviewCount = businessDomain.reviewCount
//        distance = businessDomain.distance
        rating = businessDomain.rating
        address = businessDomain.address
//        displayAddress = businessDomain.displayAddress
        city = businessDomain.city
        stateCode = businessDomain.stateCode
        postalCode = businessDomain.postalCode
        countryCode = businessDomain.countryCode
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