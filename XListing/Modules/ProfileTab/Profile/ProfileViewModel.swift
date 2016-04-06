//
// ProfileViewModel.swift
// XListing
//
// Created by Lance Zhu on 15-05-06.
// Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxOptional

final class ProfileViewModel : _BaseViewModel, IProfileViewModel, ViewModelInjectable {

    // MARK: - Inputs

    // MARK: - Outputs
    var nickname: String? {
        return myInfo?.nickname
    }
    var horoscope: Horoscope? {
        return myInfo?.horoscope
    }
    var ageGroup: AgeGroup? {
        return myInfo?.ageGroup
    }
    var gender: Gender? {
        return myInfo?.gender
    }
    var whatsUp: String? {
        return myInfo?.whatsUp
    }
    var coverPhotoURL: NSURL? {
        return myInfo?.coverPhotoURL
    }
    let myInfo: MyInfo?
    
    // MARK: - Properties
    // MARK: Services
    private let businessRepository: IBusinessRepository
    private let meRepository: IMeRepository
    private let geoLocationService: IGeoLocationService
    private let userDefaultsService: IUserDefaultsService
    
//    let profileBottomViewModel: IProfileBottomViewModel

    // MARK: Variables
    
    
    // MARK: - Initializers
    typealias Dependency = (router: IRouter, businessRepository: IBusinessRepository, meRepository: IMeRepository, geoLocationService: IGeoLocationService, userDefaultsService: IUserDefaultsService)
    typealias Token = Void
    typealias Input = Void
    
    init(dep: Dependency, token: Token, input: Input) {
        
        self.businessRepository = dep.businessRepository
        self.meRepository = dep.meRepository
        self.geoLocationService = dep.geoLocationService
        self.userDefaultsService = dep.userDefaultsService
        
        myInfo = dep.meRepository.me().map(MyInfo.init)
        
//        meRepository.
        
        super.init(router: dep.router)
        
//        profileBottomViewModel = ProfileBottomViewModel(participationService: participationService, businessService: businessService, meService: meService, geoLocationService: geoLocationService, imageService: imageService)
    }

    // MARK: - API

    func pushSocialBusinessModule() {
//        if let nav = navigator {
//            nav.pushSocialBusiness(business, animated: animated)
//        }
    }

    func presentProfileEditModule() {
//        if meService.isLoggedInAlready() {
//            if let nav = navigator {
//                nav.presentProfileEdit(animated, completion: completion)
//            }
//        }
    }
}
