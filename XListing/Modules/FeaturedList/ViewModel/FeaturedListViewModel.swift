//
//  FeaturedListViewModel.swift
//  XListing
//
//  Created by Lance Zhu on 2015-04-07.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import Realm
import SwiftTask
import ReactKit

public class FeaturedListViewModel : BaseViewModel, IFeaturedListViewModel {
    
    public override init(businessService: IBusinessService) {
        super.init(businessService: businessService)
    }
    

    public override func getBusiness() {
        //TODO: support for offline usage.
//        return dm.getFeaturedBusiness()
        prepareDataForSignal()
    }
}