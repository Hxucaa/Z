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

public class DetailViewModel : NSObject, IDetailViewModel {
    
    private let wantToGoService: IWantToGoService
    private let geoLocationService: IGeoLocationService
    
    public dynamic var business: Business!
    
    private var businessKVO: Stream<AnyObject?>!
    
    public var detailBusinessInfoVM: DetailBusinessInfoViewModel!
    
    public init(wantToGoService: IWantToGoService, geoLocationService: IGeoLocationService) {
        self.wantToGoService = wantToGoService
        self.geoLocationService = geoLocationService
        
        super.init()
        
        businessKVO = KVO.stream(self, "business")
        businessKVO ~> { [weak self] bus in
            self!.detailBusinessInfoVM = DetailBusinessInfoViewModel(business: bus as! Business)
        }
    }
    
    public func goingToBusiness(#thisWeek: Bool, thisMonth: Bool, later: Bool) -> Task<Int, WantToGo, NSError> {
        return wantToGoService.goingToBusiness(business.objectId!, thisWeek: thisWeek, thisMonth: thisMonth, later: later)
    }
    
    deinit {
        println("DetailViewModel deinit")
    }
}