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
    
    public func skipAccount(dismiss: () -> ()) {
        // if accountModuleSkipped is true, then this function has been called from other views. Call dismiss function to dismiss the current view.
        if userDefaultsService.accountModuleSkipped {
            dismiss()
        }
        // else it must be the first the app is run on device. Go straight to featured list.
        else {
            router.pushFeatured()
            userDefaultsService.accountModuleSkipped = true
        }
    }
}