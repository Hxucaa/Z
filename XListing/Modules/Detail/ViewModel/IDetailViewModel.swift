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
    var detailBusinessInfoVM: DetailBusinessInfoViewModel { get }
    var detailImageViewModel: DetailImageViewModel { mutating get }
    var detailAddressAndMapViewModel: DetailAddressAndMapViewModel { mutating get }
    init(router: IRouter, wantToGoService: IWantToGoService, geoLocationService: IGeoLocationService, businessModel: Business)
//    func goingToBusiness(#thisWeek: Bool, thisMonth: Bool, later: Bool) -> Task<Int, WantToGo, NSError>
//    func getCurrentLocation() -> Stream<CLLocation>
}