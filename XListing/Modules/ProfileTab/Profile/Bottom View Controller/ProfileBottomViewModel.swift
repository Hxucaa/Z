////
////  ProfileBottomViewModel.swift
////  XListing
////
////  Created by Lance Zhu on 2015-10-07.
////  Copyright (c) 2015 ZenChat. All rights reserved.
////
//
//import Foundation
//
//public final class ProfileBottomViewModel : IProfileBottomViewModel {
//    
//    // MARK: - Properties
//    public weak var navigator: ProfileNavigator? {
//        didSet {
//            profilePageViewModel.navigator = navigator
//        }
//    }
//    
//    // MARK: Services
//    private let businessService: IBusinessService
//    private let participationService: IParticipationService
//    private let meService: IMeService
//    private let geoLocationService: IGeoLocationService
//    private let imageService: IImageService
//    
//    // MARK: ViewModels
//    public let profilePageViewModel: IProfilePageViewModel
//    
//    
//    // MARK: - Initializers
//    
//    public init(participationService: IParticipationService, businessService: IBusinessService, meService: IMeService, geoLocationService: IGeoLocationService, imageService: IImageService) {
//        
//        self.participationService = participationService
//        self.businessService = businessService
//        self.meService = meService
//        self.geoLocationService = geoLocationService
//        self.imageService = imageService
//        
//        profilePageViewModel = ProfilePageViewModel(participationService: participationService, businessService: businessService, meService: meService, geoLocationService: geoLocationService, imageService: imageService)
//    }
//}