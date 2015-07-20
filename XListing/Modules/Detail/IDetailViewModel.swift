//
//  IDetailViewModel.swift
//  XListing
//
//  Created by Lance Zhu on 2015-04-15.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import ReactiveCocoa
import MapKit

public protocol IDetailViewModel {
    var businessName: ConstantProperty<String> { get }
    var detailImageViewModel: DetailImageViewModel { get }
    var detailAddressAndMapViewModel: DetailAddressAndMapViewModel { get }
    var detailPhoneWebViewModel: DetailPhoneWebViewModel { get }
    var detailBizInfoViewModel: DetailBizInfoViewModel { get }
    init(router: IRouter, userService: IUserService, participationService: IParticipationService, geoLocationService: IGeoLocationService, businessModel: Business)
    func pushWantToGo()
}