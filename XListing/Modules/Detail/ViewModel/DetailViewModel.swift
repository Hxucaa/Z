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

public final class DetailViewModel : NSObject, IDetailViewModel {
    
    private let navigator: INavigator
    private let wantToGoService: IWantToGoService
    private let geoLocationService: IGeoLocationService
    
    private dynamic let business: Business
    
    private var businessKVO: Stream<AnyObject?>!
    
    public var detailBusinessInfoVM: DetailBusinessInfoViewModel!
    
    public required init(navigator: INavigator, wantToGoService: IWantToGoService, geoLocationService: IGeoLocationService, businessModel: Business) {
        self.navigator = navigator
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
    
    public func pushProfileModule() {
        navigator.navigateToProfileModule()
        
    }
}