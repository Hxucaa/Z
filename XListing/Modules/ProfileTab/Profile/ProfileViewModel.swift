//
// ProfileViewModel.swift
// XListing
//
// Created by Lance Zhu on 15-05-06.
// Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import ReactiveCocoa
import AVOSCloud

public protocol ProfileNavigator : class {
    func pushSocialBusiness(business: Business, animated: Bool)
    func presentProfileEdit(animated: Bool, completion: CompletionHandler?)
}

public final class ProfileViewModel : IProfileViewModel {

    // MARK: - Inputs

    // MARK: - Outputs
    
    // MARK: - Properties
    // MARK: Services
    private let businessService: IBusinessService
    private let participationService: IParticipationService
    private let userService: IUserService
    private let geoLocationService: IGeoLocationService
    private let userDefaultsService: IUserDefaultsService
    private let imageService: IImageService
    
    // MARK: ViewModels
    public let profileUpperViewModel: IProfileUpperViewModel
    public let profileBottomViewModel: IProfileBottomViewModel

    // MARK: Variables
    public weak var navigator: ProfileNavigator!
    
    // MARK: - Initializers
    
    public init(participationService: IParticipationService, businessService: IBusinessService, userService: IUserService, geoLocationService: IGeoLocationService, userDefaultsService: IUserDefaultsService, imageService: IImageService) {
        
        self.participationService = participationService
        self.businessService = businessService
        self.userService = userService
        self.geoLocationService = geoLocationService
        self.userDefaultsService = userDefaultsService
        self.imageService = imageService
        
        profileUpperViewModel = ProfileUpperViewModel(userService: userService, imageService: imageService)
        profileBottomViewModel = ProfileBottomViewModel(participationService: participationService, businessService: businessService, userService: userService, geoLocationService: geoLocationService, imageService: imageService)
    }

    // MARK: - API

    public func pushSocialBusinessModule(section: Int, animated: Bool) {
//        navigator.pushSocialBusiness(businessArr.value[section], animated: animated)
    }

    public func presentProfileEditModule(animated: Bool, completion: CompletionHandler? = nil) {
        if userService.isLoggedInAlready() {
            navigator.presentProfileEdit(animated, completion: completion)
        }
    }


}
