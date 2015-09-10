//
//  ISocialBusiness_UserViewModel.swift
//  XListing
//
//  Created by Lance Zhu on 2015-09-04.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import ReactiveCocoa

public protocol ISocialBusiness_UserViewModel : class {
    
    // MARK: - Outputs
    var profileImage: PropertyOf<UIImage?> { get }
    var nickname: PropertyOf<String> { get }
    var ageGroup: PropertyOf<String> { get }
    var horoscope: PropertyOf<String> { get }
    var status: PropertyOf<String> { get }
    var participationType: PropertyOf<String> { get }
    var gender: PropertyOf<String> { get }
    
    // MARK: - Initializers
    init(participationService: IParticipationService, imageService: IImageService, user: User?)
}