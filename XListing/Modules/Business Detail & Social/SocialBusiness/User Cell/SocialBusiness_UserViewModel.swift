////
////  SocialBusiness_UserViewModel.swift
////  XListing
////
////  Created by Lance Zhu on 2015-09-04.
////  Copyright (c) 2015 ZenChat. All rights reserved.
////
//
//import Foundation
//import ReactiveCocoa
//import ReactiveArray
//import Dollar
//import AVOSCloud
//
//final class SocialBusiness_UserViewModel : BasicUserInfoViewModel, ISocialBusiness_UserViewModel {
//    
//    // MARK: - Outputs
//    
//    private let _participationType: MutableProperty<String>
//    var participationType: AnyProperty<String> {
//        return AnyProperty(_participationType)
//    }    
//    
//    // MARK: - Properties
//    let user: User
//    private let imageService: IImageService
//    private let participationService: IParticipationService
//
//    
//    // MARK: - Initializers
//    init(participationService: IParticipationService, imageService: IImageService, user: User, eventType: EventType) {
//        self.participationService = participationService
//        self.imageService = imageService
//        
//        self.user = user
//        
//        _participationType = MutableProperty(eventType.description)
//        
//        super.init(imageService: imageService, user: user)
//    }
//}

struct UserInfo {
    let nickname: String
    let gender: Gender
    let ageGroup: AgeGroup
    let horoscope: Horoscope
    let coverPhoto: ImageFile?
    let whatsUp: String?
    let aaCount: Int
    let treatCount: Int
    let toGoCount: Int
    
    init(user: User) {
        nickname = user.nickname
        gender = user.gender
        ageGroup = user.ageGroup
        horoscope = user.horoscope
        coverPhoto = user.coverPhoto
        whatsUp = user.whatsUp
        aaCount = user.aaCount
        treatCount = user.treatCount
        toGoCount = user.toGoCount
    }
}