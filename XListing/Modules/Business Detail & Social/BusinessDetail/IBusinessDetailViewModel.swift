//
//  IBusinessDetailViewModel.swift
//  XListing
//
//  Created by Lance Zhu on 2015-09-09.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import ReactiveCocoa

public protocol IBusinessDetailViewModel : class {
    
    // MARK: Outputs
    var businessName: ConstantProperty<String> { get }
    var webSiteURL: ConstantProperty<NSURL?> { get }
    
    var headerViewModel: SocialBusinessHeaderViewModel { get }
    var descriptionViewModel: DescriptionCellViewModel { get }
    var detailAddressAndMapViewModel: DetailAddressAndMapViewModel { get }
    var detailPhoneWebViewModel: DetailPhoneWebViewModel { get }
    var detailNavigationMapViewModel: DetailNavigationMapViewModel { get }
    var businessHourViewModel: BusinessHourCellViewModel { get }
    
    init(meService: IMeService, participationService: IParticipationService, geoLocationService: IGeoLocationService, imageService: IImageService, business: Business)
    
    // MARK: Actions
    func callPhone() -> SignalProducer<Bool, NoError>
}