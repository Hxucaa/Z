//
//  BusinessInfo.swift
//  XListing
//
//  Created by Lance Zhu on 2016-04-03.
//  Copyright © 2016 Lance Zhu. All rights reserved.
//

import Foundation
import MapKit

struct BusinessInfo {
    let objectId: String
    let createdAt: NSDate
    let updatedAt: NSDate
    
    let name: String
    let phone: String
    let email: String?
    let websiteUrl: NSURL?
    let street: String
    let district: String
    let city: String
    let province: String
    let coverImageUrl: NSURL?
    let description: String?
    let averagePrice: String
    let aaCount: Int
    let treatCount: Int
    let toGoCount: Int
    let geolocation: CLLocation
    
    let business: Business
    
    init(business: Business) {
        objectId = business.objectId
        createdAt = business.createdAt
        updatedAt = business.updatedAt
        
        name = business.name
        phone = business.phone
        email = business.email
        websiteUrl = business.websiteUrl
        street = business.address.street
        district = business.address.district.regionNameC
        city = business.address.city.regionNameC
        province = business.address.province.regionNameC
        // FIXME: placeholder
//        coverImageUrl = business.coverImage.url
        let images = ["http://i.imgur.com/811P1Ii.png", "http://i.imgur.com/3kWh8wvh.jpg", "http://i.imgur.com/KARJcfNg.jpg", "http://i.imgur.com/uaQBLrIg.jpg", "http://i.imgur.com/FkdHm1R.jpg", "http://i.imgur.com/F6XgTwyr.jpg"]
        
        coverImageUrl = images[Int(arc4random_uniform(UInt32(images.count)))] |> { NSURL(string: $0) }
        description = business.descriptor
        averagePrice = "30"
        aaCount = business.aaCount
        treatCount = business.treatCount
        toGoCount = business.toGoCount
        geolocation = business.address.geoLocation.cllocation
        
        self.business = business
    }
}
