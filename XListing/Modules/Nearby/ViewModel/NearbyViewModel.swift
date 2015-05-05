//
//  NearbyViewModel.swift
//  XListing
//
//  Created by Lance Zhu on 2015-04-12.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import Realm
import SwiftTask
import ReactKit

public class NearbyViewModel : BaseViewModel, INearbyViewModel {    
    
    public override init(businessService: IBusinessService) {
        super.init(businessService: businessService)
    }
    
}