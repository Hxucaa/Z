//
//  User.swift
//  XListing
//
//  Created by Lance Zhu on 2016-03-19.
//  Copyright © 2016 ZenChat. All rights reserved.
//

import Foundation

public class _BaseUser {
    public let objectId: String
    
    public let status: UserStatus
    public let nickname: String
    public let gender: Gender
    public let ageGroup: AgeGroup
    public let horoscope: Horoscope
    public let coverPhoto: ImageFile?
    public let whatsUp: String?
    public let latestLocation: Geolocation?
    public let aaCount: Int
    public let treatCount: Int
    public let toGoCount: Int
    
    public init(objectId: String, status: UserStatus, nickname: String, gender: Gender, ageGroup: AgeGroup, horoscope: Horoscope, coverPhoto: ImageFile?, whatsUp: String?, latestLocation: Geolocation?, aaCount: Int, treatCount: Int, toGoCount: Int) {
        
        self.objectId = objectId
        
        self.status = status
        self.nickname = nickname
        self.gender = gender
        self.ageGroup = ageGroup
        self.horoscope = horoscope
        self.coverPhoto = coverPhoto
        self.whatsUp = whatsUp
        self.latestLocation = latestLocation
        self.aaCount = aaCount
        self.treatCount = treatCount
        self.toGoCount = toGoCount
    }
}

public class User : _BaseUser {
    
}

public class BusinessUser : _BaseUser {
    
}

public class Me : User {
    public let updatedAt: NSDate
    public let createdAt: NSDate
    
    public let address: Address?
    public let birthday: NSDate
    
    public init(objectId: String, updatedAt: NSDate, createdAt: NSDate, birthday: NSDate, address: Address?, status: UserStatus, nickname: String, gender: Gender, ageGroup: AgeGroup, horoscope: Horoscope, coverPhoto: ImageFile?, whatsUp: String?, latestLocation: Geolocation?, aaCount: Int, treatCount: Int, toGoCount: Int) {
        
        self.updatedAt = updatedAt
        self.createdAt = createdAt
        self.address = address
        self.birthday = birthday
        
        super.init(objectId: objectId, status: status, nickname: nickname, gender: gender, ageGroup: ageGroup, horoscope: horoscope, coverPhoto: coverPhoto, whatsUp: whatsUp, latestLocation: latestLocation, aaCount: aaCount, treatCount: treatCount, toGoCount: toGoCount)
    }
}
