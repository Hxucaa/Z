//
//  DetailViewModel.swift
//  XListing
//
//  Created by Lance Zhu on 2015-04-15.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import ReactiveCocoa
import MapKit

public struct DetailViewModel : IDetailViewModel {
    
    public let detailBusinessInfoVM: DetailBusinessInfoViewModel
    
    public private(set) lazy var detailImageViewModel: DetailImageViewModel = DetailImageViewModel(coverImage: self.business.cover)

    public private(set) lazy var detailAddressAndMapViewModel: DetailAddressAndMapViewModel = DetailAddressAndMapViewModel(geoLocationService: self.geoLocationService, businessName: self.business.nameSChinese, address: self.business.address, city: self.business.city, state: self.business.state, geopoint: self.business.geopoint)
    
    // MARK: Initializers
    public init(router: IRouter, wantToGoService: IWantToGoService, geoLocationService: IGeoLocationService, businessModel: Business) {
        self.router = router
        self.wantToGoService = wantToGoService
        self.geoLocationService = geoLocationService
        self.business = businessModel
        self.detailBusinessInfoVM = DetailBusinessInfoViewModel(business: businessModel)
    }
    
    // MARK: - Private
    
    // MARK: Services
    private let router: IRouter
    private let wantToGoService: IWantToGoService
    private let geoLocationService: IGeoLocationService
    
    private let business: Business
    
//    public func goingToBusiness(#thisWeek: Bool, thisMonth: Bool, later: Bool) -> Task<Int, WantToGo, NSError> {
//        return wantToGoService.goingToBusiness(business.objectId!, thisWeek: thisWeek, thisMonth: thisMonth, later: later)
//    }
    
    /**
    Get current geo location. If location service fails for any reason, use hardcoded geo location instead.
    
    :returns: A Task that contains a geo location.
    */
//    public func getCurrentLocation() -> Stream<CLLocation> {
//        return Stream<CLLocation?>.fromTask(geoLocationService.getCurrentLocation()
//        )
//    }
}