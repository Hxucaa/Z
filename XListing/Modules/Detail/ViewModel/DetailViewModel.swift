//
//  DetailViewModel.swift
//  XListing
//
//  Created by Lance Zhu on 2015-04-15.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import SwiftTask
import ReactKit
import MapKit

public final class DetailViewModel : NSObject, IDetailViewModel {
    
    private let router: IRouter
    private let wantToGoService: IWantToGoService
    private let geoLocationService: IGeoLocationService
    
    private dynamic let business: Business
    
    private var businessKVO: Stream<AnyObject?>!
    
    public var detailBusinessInfoVM: DetailBusinessInfoViewModel!
    
    public required init(router: IRouter, wantToGoService: IWantToGoService, geoLocationService: IGeoLocationService, businessModel: Business) {
        self.router = router
        self.wantToGoService = wantToGoService
        self.geoLocationService = geoLocationService
        self.business = businessModel
        
        super.init()
        
        businessKVO = KVO.startingStream(self, "business")
        businessKVO ~> { [unowned self] bus in
            self.detailBusinessInfoVM = DetailBusinessInfoViewModel(business: bus as! Business)
        }
    }
    
    public func goingToBusiness(#thisWeek: Bool, thisMonth: Bool, later: Bool) -> Task<Int, WantToGo, NSError> {
        return wantToGoService.goingToBusiness(business.objectId!, thisWeek: thisWeek, thisMonth: thisMonth, later: later)
    }
    
    /**
    Get current geo location. If location service fails for any reason, use hardcoded geo location instead.
    
    :returns: A Task that contains a geo location.
    */
    public func getCurrentLocation() -> Stream<CLLocation> {
        return Stream<CLLocation?>.fromTask(geoLocationService.getCurrentLocation()
        )
    }
}