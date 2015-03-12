//
//  BusinessDomain.swift
//  XListing
//
//  Created by Lance Zhu on 2015-03-08.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation

struct BusinessDomain : Printable {
    var isClaimed: Bool?
    var isClosed: Bool?
    var name: String?
    var imageUrl: String?
    var url: String?
    var mobileUrl: String?
    var phone: String?
    var displayPhone: String?
    var reviewCount: Int?
    var distance: Double?
    var rating: Double?
    var address: [String]?
    var displayAddress: [String]?
    var city: String?
    var stateCode: String?
    var postalCode: String?
    var countryCode: String?
    var crossStreets: String?
    var neighborhoods: [String]?
    
    init(business: BusinessEntity) {
        isClaimed = business.isClaimed
        isClosed = business.isClosed
        name = business.name
        imageUrl = business.imageUrl
        url = business.url
        mobileUrl = business.mobileUrl
        phone = business.phone
        displayPhone = business.displayPhone
        reviewCount = business.reviewCount
        distance = business.distance
        rating = business.rating
        let loc = business.location
        address = loc?.address
        displayAddress = loc?.displayAddress
        city = loc?.city
        stateCode = loc?.stateCode
        postalCode = loc?.postalCode
        countryCode = loc?.countryCode
        crossStreets = loc?.crossStreets
        neighborhoods = loc?.neighborhoods
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