//
//  SocialBusinessViewModel.swift
//  XListing
//
//  Created by Lance Zhu on 2015-08-30.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import ReactiveCocoa
import AVOSCloud
import Dollar
import ReactiveArray

public protocol SocialBusinessNavigator : class {
    
}

// TODO: Make this class comform to `ICollectionDataSource`
public final class SocialBusinessViewModel : ISocialBusinessViewModel  {
    
    // MARK: - Inputs
    
    // MARK: - Outputs
    
    // MARK: - Properties
    // MARK: Services
    private let userService: IUserService
    private let participationService: IParticipationService
    private let geoLocationService: IGeoLocationService
    private let imageService: IImageService
    private let business: Business
    
    // MARK: Variables
    public weak var navigator: SocialBusinessNavigator!
    
    // MARK: - Initializers
    public init(userService: IUserService, participationService: IParticipationService, geoLocationService: IGeoLocationService, imageService: IImageService, businessModel: Business) {
        self.userService = userService
        self.participationService = participationService
        self.geoLocationService = geoLocationService
        self.imageService = imageService
        self.business = businessModel
        
    }
    
    // MARK: - API
    
    // MARK: - Others
}