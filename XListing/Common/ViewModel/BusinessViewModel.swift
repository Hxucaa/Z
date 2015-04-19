//
//  BusinessViewModel.swift
//  XListing
//
//  Created by Lance Zhu on 2015-04-08.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import Realm
import SwiftTask

/**
*  Constants
*/
private let 公里 = "公里"
private let 米 = "米"

public class BusinessViewModel {
    
    public private(set) var objectId: String?
    public private(set) var remoteCreatedAt: NSDate?
    public private(set) var remoteUpdatedAt: NSDate?
    
    /**
    *  Business info
    */
    public private(set) var nameSChinese: String?
    public private(set) var nameTChinese: String?
    public private(set) var nameEnglish: String?
    public private(set) var isClaimed: Bool = false
    public private(set) var isClosed: Bool = false
    public private(set) var phone: String?
    public private(set) var url: String?
    public private(set) var mobileUrl: String?
    public private(set) var uid: String?
    public private(set) var imageUrl: String?
    public private(set) var reviewCount: Int = 0
    public private(set) var rating: Double = -1
    public private(set) var coverImageUrl: String?
    
    /**
    *  Featured
    */
    public private(set) var featured: Bool = false
    public private(set) var timeStart: NSDate?
    public private(set) var timeEnd: NSDate?
    
    /**
    *  Location
    */
    public private(set) var unit: String?
    public private(set) var address: String?
    public private(set) var district: String?
    public private(set) var city: String?
    public private(set) var state: String?
    public private(set) var country: String?
    public private(set) var postalCode: String?
    public private(set) var crossStreets: String?
    public private(set) var latitude: Double?
    public private(set) var longitude: Double?
    
    public private(set) var distance: String?
    
    
    public init(business: Business, distanceInMeter: CLLocationDistance) {
        objectId = business.objectId
        remoteCreatedAt = NSDate(timeIntervalSince1970: business.remoteCreatedAt)
        remoteUpdatedAt = NSDate(timeIntervalSince1970: business.remoteUpdatedAt)
        
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
        coverImageUrl = business.coverImageUrl
        
        featured = business.featured
        timeStart = NSDate(timeIntervalSince1970: business.timeStart)
        timeEnd = NSDate(timeIntervalSince1970: business.timeEnd)
        
        unit = business.unit
        address = business.address
        district = business.district
        city = business.city
        state = business.state
        country = business.country
        postalCode = business.postalCode
        crossStreets = business.crossStreets
        latitude = business.latitude
        longitude = business.longitude
        
        let formatter = NSNumberFormatter()
        formatter.numberStyle = NSNumberFormatterStyle.DecimalStyle
        if(distanceInMeter >= 1000) {
            formatter.maximumFractionDigits = 1
            self.distance = formatter.stringFromNumber(distanceInMeter / 1000)! + 公里
        }
        else {
            formatter.maximumFractionDigits = 0
            self.distance = formatter.stringFromNumber(distanceInMeter)! + 米
        }

       
        println(coverImageUrl)

        coverImageUrl = "http://www.afroglobe.net/wp-content/uploads/2015/03/Wonderful-Life-With-Fantastic-Chinese-Restaurant-Design-Idea-2.jpg"
        
    }
}

extension BusinessViewModel : Printable {
    
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