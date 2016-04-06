//
//  UserInfo.swift
//  XListing
//
//  Created by Lance Zhu on 2016-04-03.
//  Copyright © 2016 ZenChat. All rights reserved.
//

import Foundation

struct AddressInfo {
    
    let objectId: String
    let createdAt: NSDate
    let updatedAt: NSDate
    
    let street: String
//    let district: String
    let city: String
    let province: String
    let postalCode: String?
    let geolocation: CLLocation
    
    init(address: Address) {
        objectId = address.objectId
        createdAt = address.createdAt
        updatedAt = address.updatedAt
        
        
        street = address.street
        city = address.city.regionNameC
        province = address.province.regionNameC
        postalCode = address.postalCode
        geolocation = address.geoLocation.cllocation
    }
}

struct UserInfo {
    let nickname: String
    let gender: Gender
    let ageGroup: AgeGroup
    let horoscope: Horoscope
    let coverPhotoURL: NSURL?
    let whatsUp: String?
    let aaCount: Int
    let treatCount: Int
    let toGoCount: Int
    
    init(user: User) {
        nickname = user.nickname
        gender = user.gender
        ageGroup = user.ageGroup
        horoscope = user.horoscope
        // FIXME: placeholder
//        coverPhotoURL = user.coverPhoto?.url
        coverPhotoURL = "http://i.imgur.com/hfgzBeW.jpg" |> NSURL.init
        whatsUp = user.whatsUp
        aaCount = user.aaCount
        treatCount = user.treatCount
        toGoCount = user.toGoCount
    }
}

struct MyInfo {
    let objectId: String
    let createdAt: NSDate
    let updatedAt: NSDate
    
    let nickname: String
    let gender: Gender
    let ageGroup: AgeGroup
    let horoscope: Horoscope
    let coverPhotoURL: NSURL?
    let whatsUp: String?
    let aaCount: Int
    let treatCount: Int
    let toGoCount: Int
    
    let birthday: NSDate
    let address: AddressInfo?
    
    init(me: Me) {
        objectId = me.objectId
        createdAt = me.createdAt
        updatedAt = me.updatedAt
        
        nickname = me.nickname
        gender = me.gender
        ageGroup = me.ageGroup
        horoscope = me.horoscope
        // FIXME: placeholder
        //        coverPhotoURL = user.coverPhoto?.url
        coverPhotoURL = "http://i.imgur.com/hfgzBeW.jpg" |> NSURL.init
        whatsUp = me.whatsUp
        aaCount = me.aaCount
        treatCount = me.treatCount
        toGoCount = me.toGoCount
        
        birthday = me.birthday
        address = me.address.map(AddressInfo.init)
    }
}