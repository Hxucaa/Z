//
//  NearbyViewModel.swift
//  XListing
//
//  Created by Lance Zhu on 2015-04-12.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import SwiftTask
import ReactKit

public class NearbyViewModel : BaseViewModel, INearbyViewModel {    
    
    public override init(businessService: IBusinessService, geoLocationService: IGeoLocationService) {
        super.init(businessService: businessService, geoLocationService: geoLocationService)
    }
    
    public func getBusiness() {
        let query = BusinessDAO.query()!
        super.getBusiness(query)
    }
    
    public func pushDetailModule(businessViewModel: BusinessViewModel) {
        
        NSNotificationCenter.defaultCenter().postNotificationName(NavigationNotificationName.PushDetailModule, object: nil, userInfo: ["viewmodel" : businessViewModel])
    }
}