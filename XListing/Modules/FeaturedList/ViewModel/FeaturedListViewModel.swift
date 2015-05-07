//
//  FeaturedListViewModel.swift
//  XListing
//
//  Created by Lance Zhu on 2015-04-07.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import SwiftTask
import ReactKit

public class FeaturedListViewModel : BaseViewModel, IFeaturedListViewModel {
    
    public override init(businessService: IBusinessService, geoLocationService: IGeoLocationService) {
        super.init(businessService: businessService, geoLocationService: geoLocationService)
    }

    public func getBusiness() {
        let query = BusinessDAO.query()!
        query.whereKey("featured", equalTo: true);
        super.getBusiness(query)
    }
}