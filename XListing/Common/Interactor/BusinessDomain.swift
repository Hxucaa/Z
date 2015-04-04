//
//  BusinessDomain.swift
//  XListing
//
//  Created by Lance Zhu on 2015-03-08.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation

public class BusinessDomain : Printable {
    public var objectId: String?
    public var updatedAt: NSDate?
    public var createdAt: NSDate?
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
    public var featured: Bool?
    public var timeStart: NSDate?
    public var timeEnd: NSDate?
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
    
    init() {
        
    }
    
    public func fromEntity(business: BusinessEntity, distance: Double?) {
        objectId = business.objectId
        updatedAt = business.updatedAt
        createdAt = business.createdAt
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
        featured = business.featured
        timeStart = business.timeStart
        timeEnd = business.timeEnd
        unit = business.unit
        address = business.address
        district = business.district
        city = business.city
        state = business.state
        country = business.country
        postalCode = business.postalCode
        crossStreets = business.crossStreets
        neighborhoods = business.neighborhoods
        self.distance = distance
        
        
    }
    
    public func toEntity() -> BusinessEntity {
        let business = BusinessEntity()
        if objectId != nil {
            business.objectId = objectId
        }
        if nameSChinese != nil {
            business.nameSChinese = nameSChinese
        }
        if nameTChinese != nil {
            business.nameTChinese = nameTChinese
        }
        if nameEnglish != nil {
            business.nameEnglish = nameEnglish
        }
        if isClaimed != nil {
            business.isClaimed = isClaimed
        }
        if isClosed != nil {
            business.isClosed = isClosed
        }
        if phone != nil {
            business.phone = phone
        }
        if url != nil {
            business.url = url
        }
        if mobileUrl != nil {
            business.mobileUrl = mobileUrl
        }
        if uid != nil {
            business.uid = uid
        }
        if imageUrl != nil {
            business.imageUrl = imageUrl
        }
        if reviewCount != nil {
            business.reviewCount = reviewCount
        }
        if rating != nil {
            business.rating = rating
        }
        if featured != nil {
            business.featured = featured
        }
        if timeStart != nil {
            business.timeStart = timeStart
        }
        if timeEnd != nil {
            business.timeEnd = timeEnd
        }
        if unit != nil {
            business.unit = unit
        }
        if address != nil {
            business.address = address
        }
        if district != nil {
            business.district = district
        }
        if city != nil {
            business.city = city
        }
        if state != nil {
            business.state = state
        }
        if country != nil {
            business.country = country
        }
        if postalCode != nil {
            business.postalCode = postalCode
        }
        if crossStreets != nil {
            business.crossStreets = crossStreets
        }
        if neighborhoods != nil {
            business.neighborhoods = neighborhoods
        }
        
        return business
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