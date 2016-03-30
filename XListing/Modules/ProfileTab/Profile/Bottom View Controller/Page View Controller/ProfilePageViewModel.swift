////
////  ProfilePageViewModel.swift
////  XListing
////
////  Created by Lance Zhu on 2015-10-08.
////  Copyright (c) 2015 ZenChat. All rights reserved.
////
//
//import Foundation
//
//public final class ProfilePageViewModel : IProfilePageViewModel {
//    
//    // MARK: - Properties
//    public weak var navigator: ProfileNavigator? {
//        didSet {
//            participationListViewModel.navigator = navigator
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
//    public let photoManagerViewModel: IPhotoManagerViewModel
//    public let participationListViewModel: IParticipationListViewModel
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
//        photoManagerViewModel = PhotoManagerViewModel(meService: meService, imageService: imageService)
//        
//        participationListViewModel = ParticipationListViewModel(participationService: participationService, businessService: businessService, meService: meService, geoLocationService: geoLocationService, imageService: imageService)
//    }
//    
//}
