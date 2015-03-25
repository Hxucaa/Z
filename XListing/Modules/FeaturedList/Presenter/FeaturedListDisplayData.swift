//
//  FeaturedListDisplayData.swift
//  XListing
//
//  Created by Lance Zhu on 2015-03-09.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation

let 公里 = "公里"
let 米 = "米"

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
    var distance: String?
    
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
        reviewCount = businessDomain.reviewCount
        rating = businessDomain.rating
        unit = businessDomain.unit
        address = businessDomain.address
        district = businessDomain.district
        city = businessDomain.city
        state = businessDomain.state
        country = businessDomain.country
        postalCode = businessDomain.postalCode
        crossStreets = businessDomain.crossStreets
        neighborhoods = businessDomain.neighborhoods
        if let d = businessDomain.distance {
            var rounded: Double
            if(d >= 1) {
                rounded = round(d * 10) / 10
                distance = rounded.description + 公里
            }
            else {
                rounded = round(d * 1000) / 1000
                distance = rounded.description + 米
            }
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