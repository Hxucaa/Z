////
////  ParticipationListCellViewModel.swift
////  XListing
////
////  Created by Lance Zhu on 2015-10-07.
////  Copyright (c) 2015 ZenChat. All rights reserved.
////
//
//import Foundation
//import ReactiveCocoa
//import Dollar
//
//public final class ParticipationListCellViewModel : IParticipationListCellViewModel {
//    
//    // MARK: - Inputs
//    
//    // MARK: - Outputs
//    private let _coverImage: MutableProperty<UIImage?> = MutableProperty(UIImage(named: ImageAssets.businessplaceholder))
//    public var coverImage: AnyProperty<UIImage?> {
//        return AnyProperty(_coverImage)
//    }
//    
//    // MARK: - Properties
//    private let meService: IMeService
//    private let geoLocationService: IGeoLocationService
//    private let imageService: IImageService
//    private let participationService: IParticipationService
//    private let business: Business
//    
//    // MARK: ViewModels
//    public let infoPanelViewModel: ProfileTabInfoPanelViewModel
//    public let statusButtonViewModel: ProfileTabStatusButtonViewModel
//    
//    // MARK: - Initializers
//    public init(meService: IMeService, geoLocationService: IGeoLocationService, imageService: IImageService, participationService: IParticipationService, coverImage: ImageFile?, geolocation: Geolocation, business: Business, type: ParticipationType?) {
//        
//        self.meService = meService
//        self.geoLocationService = geoLocationService
//        self.imageService = imageService
//        self.participationService = participationService
//        self.business = business
//        
//        
//        infoPanelViewModel = ProfileTabInfoPanelViewModel(geoLocationService: geoLocationService, imageService: imageService, business: business)
//        statusButtonViewModel = ProfileTabStatusButtonViewModel(type: type)
//    }
//    
//    // MARK: - Others
//    
//    public func getCoverImage() -> SignalProducer<Void, NSError> {
//        if let nsurl = NSURL(string: business.coverImage.url) {
//            return imageService.getImageBy(nsurl)
//                .on(next: {
//                    self._coverImage.value = $0
//                })
//                .map { _ in return }
//        }
//        else {
//            return SignalProducer<Void, NSError>.empty
//        }
//    }
//    
//    
//}