//
//  UserInfo.swift
//  XListing
//
//  Created by Lance Zhu on 2016-04-03.
//  Copyright © 2016 ZenChat. All rights reserved.
//

import Foundation


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
