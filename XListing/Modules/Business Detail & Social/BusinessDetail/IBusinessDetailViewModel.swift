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
    var businessName: AnyProperty<String> { get }
    var headerViewModel: SocialBusinessHeaderViewModel { get }
//    var detailImageViewModel: DetailImageViewModel { get }
    var detailAddressAndMapViewModel: DetailAddressAndMapViewModel { get }
    var detailPhoneWebViewModel: DetailPhoneWebViewModel { get }
//    var detailBizInfoViewModel: DetailBizInfoViewModel { get }
    var detailNavigationMapViewModel: DetailNavigationMapViewModel { get }
//    var detailParticipationViewModel: DetailParticipationViewModel { get }
    var businessHourViewModel: BusinessHourCellViewModel { get }
    init(userService: IUserService, participationService: IParticipationService, geoLocationService: IGeoLocationService, imageService: IImageService, business: Business)
    
}