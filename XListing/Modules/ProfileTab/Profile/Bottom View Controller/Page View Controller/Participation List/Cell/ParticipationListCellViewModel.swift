//
//  ParticipationListCellViewModel.swift
//  XListing
//
//  Created by Lance Zhu on 2015-10-07.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import ReactiveCocoa
import Dollar

public final class ParticipationListCellViewModel : IParticipationListCellViewModel {
    
    // MARK: - Inputs

    // MARK: - Outputs
    private let _coverImage: MutableProperty<UIImage?> = MutableProperty(UIImage(named: ImageAssets.businessplaceholder))
    public var coverImage: PropertyOf<UIImage?> {
        return PropertyOf(_coverImage)
    }
    
    // MARK: - Properties
    private let userService: IUserService
    private let geoLocationService: IGeoLocationService
    private let imageService: IImageService
    private let participationService: IParticipationService
    private let business: Business
    
    // MARK: ViewModels
    public let infoPanelViewModel: ProfileTabInfoPanelViewModel
    public let statusButtonViewModel: ProfileTabStatusButtonViewModel

    // MARK: - Initializers
    public init(userService: IUserService, geoLocationService: IGeoLocationService, imageService: IImageService, participationService: IParticipationService, cover: ImageFile?, geolocation: Geolocation?, business: Business?, type: ParticipationType?) {
        
        self.userService = userService
        self.geoLocationService = geoLocationService
        self.imageService = imageService
        self.participationService = participationService
        self.business = business!
    

        infoPanelViewModel = ProfileTabInfoPanelViewModel(geoLocationService: geoLocationService, businessName: business?.nameSChinese, city: business?.city, district: business?.district, price: business?.price, geolocation: geolocation)
        statusButtonViewModel = ProfileTabStatusButtonViewModel(type: type)
    }
    
    // MARK: - Others
    
    public func getCoverImage() -> SignalProducer<Void, NSError> {
        if let url = business.cover_?.url, nsurl = NSURL(string: url) {
            return imageService.getImage(nsurl)
                |> on(next: {
                    self._coverImage.put($0)
                })
                |> map { _ in return }
        }
        else {
            return SignalProducer<Void, NSError>.empty
        }
    }
    
    
}