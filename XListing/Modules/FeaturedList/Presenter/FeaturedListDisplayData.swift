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

public struct FeaturedListDisplayData : Printable {
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
    public var distance: String?
    
    public init(businessDomain: BusinessDomain) {
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