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
    func presentFullScreenImage(animated: Bool, completion: CompletionHandler?)
}

public final class ProfileViewModel : IProfileViewModel {

    // MARK: - Inputs

    // MARK: - Outputs
    
    // MARK: - Properties
    // MARK: Services
    private let businessService: IBusinessService
    private let participationService: IParticipationService
    private let meService: IMeService
    private let geoLocationService: IGeoLocationService
    private let userDefaultsService: IUserDefaultsService
    private let imageService: IImageService
    
    // MARK: ViewModels
    public let profileUpperViewModel: IProfileUpperViewModel
    public let profileBottomViewModel: IProfileBottomViewModel

    // MARK: Variables
    public weak var navigator: ProfileNavigator? {
        didSet {
            profileBottomViewModel.navigator = navigator
        }
    }
    
    // MARK: - Initializers
    
    public init(participationService: IParticipationService, businessService: IBusinessService, meService: IMeService, geoLocationService: IGeoLocationService, userDefaultsService: IUserDefaultsService, imageService: IImageService) {
        
        self.participationService = participationService
        self.businessService = businessService
        self.meService = meService
        self.geoLocationService = geoLocationService
        self.userDefaultsService = userDefaultsService
        self.imageService = imageService
        
        profileUpperViewModel = ProfileUpperViewModel(meService: meService, imageService: imageService)
        profileBottomViewModel = ProfileBottomViewModel(participationService: participationService, businessService: businessService, meService: meService, geoLocationService: geoLocationService, imageService: imageService)
    }

    // MARK: - API

    public func pushSocialBusinessModule(business: Business, animated: Bool) {
        if let nav = navigator {
            nav.pushSocialBusiness(business, animated: animated)
        }
    }

    public func presentProfileEditModule(animated: Bool, completion: CompletionHandler? = nil) {
        if meService.isLoggedInAlready() {
            if let nav = navigator {
                nav.presentProfileEdit(animated, completion: completion)
            }
        }
    }
    
    public func presentFullScreenImageModule(animated: Bool, completion: CompletionHandler? = nil) {
        if let nav = navigator {
            nav.presentFullScreenImage(animated, completion: completion)
        }
    }


}
