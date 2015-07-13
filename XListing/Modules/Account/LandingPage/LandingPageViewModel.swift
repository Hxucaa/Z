//
//  LandingPageViewModel.swift
//  XListing
//
//  Created by Lance Zhu on 2015-06-15.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import ReactiveCocoa

public struct LandingPageViewModel {
    
    private let userDefaultsService: IUserDefaultsService
    private let router: IRouter
    
    public init(userDefaultsService: IUserDefaultsService, router: IRouter) {
        self.userDefaultsService = userDefaultsService
        self.router = router
    }
}