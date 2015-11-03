//
//  FeaturedBusinessViewModel.swift
//  XListing
//
//  Created by Lance Zhu on 2015-06-18.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import ReactiveCocoa

public final class FeaturedBusinessViewModel : IFeaturedBusinessViewModel {
    
    // MARK: - Outputs
    private let _coverImage: MutableProperty<UIImage?> = MutableProperty(UIImage(named: ImageAssets.businessplaceholder))
    public var coverImage: PropertyOf<UIImage?> {
        return PropertyOf(_coverImage)
    }
    
    // MARK: - ViewModels
    public let infoPanelViewModel: IFeaturedListBusinessCell_InfoPanelViewModel
    public let pariticipationViewModel: IFeaturedListBusinessCell_ParticipationViewModel
    
    // MARK: - Properties
    private let userService: IUserService
    private let geoLocationService: IGeoLocationService
    private let imageService: IImageService
    private let participationService: IParticipationService
    private let business: Business
    
    // MARK: - Initializers
    public init(userService: IUserService, geoLocationService: IGeoLocationService, imageService: IImageService, participationService: IParticipationService, cover: ImageFile?, geolocation: Geolocation?, treatCount: Int, aaCount: Int, toGoCount: Int, business: Business?) {
        
        self.userService = userService
        self.geoLocationService = geoLocationService
        self.imageService = imageService
        self.participationService = participationService
        
        self.business = business!
        
        infoPanelViewModel = FeaturedListBusinessCell_InfoPanelViewModel(geoLocationService: geoLocationService, businessName: business?.nameSChinese, city: business?.city, district: business?.district, price: business?.price, geolocation: geolocation)
        pariticipationViewModel = FeaturedListBusinessCell_ParticipationViewModel(userService: userService, imageService: imageService, participationService: participationService, business: business)
    }

    
    // MARK: - Setups
    
    // MARK: - API
    
    public func getCoverImage() -> SignalProducer<Void, NSError> {
        if let url = business.cover_?.url, nsurl = NSURL(string: url) {
            return imageService.getImage(nsurl)
                .on(next: {
                    self._coverImage.put($0)
                })
                .map { _ in return }
        }
        else {
            return SignalProducer<Void, NSError>.empty
        }
    }
    
}