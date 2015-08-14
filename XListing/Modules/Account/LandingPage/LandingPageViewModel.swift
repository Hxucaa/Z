//
//  LandingPageViewModel.swift
//  XListing
//
//  Created by Lance Zhu on 2015-04-23.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import ReactiveCocoa
import AVOSCloud

public final class LandingPageViewModel : ILandingPageViewModel {
    
    // MARK: Services
    private weak var accountNavigator: IAccountNavigator!
    private let userService: IUserService
    private let userDefaultsService: IUserDefaultsService
    
    public init(accountNavigator: IAccountNavigator, userService: IUserService, userDefaultsService: IUserDefaultsService) {
        self.accountNavigator = accountNavigator
        self.userService = userService
        self.userDefaultsService = userDefaultsService
    }
    
    deinit {
        // Dispose signals before deinit.
        AccountLogVerbose("LandingPage View Model deinitializes.")
    }
    
    public func goToSignUpComponent() {
        accountNavigator.goToSignUpComponent()
    }
    
    public func goToLogInComponent() {
        accountNavigator.goToLogInComponent()
    }
    
    public func skipAccountModule(dismiss: () -> ()) {
        if userDefaultsService.accountModuleSkipped {
            dismiss()
        }
        else {
            accountNavigator.goToFeaturedModule(nil)
            userDefaultsService.accountModuleSkipped = true
        }
    }
    
    public var rePrompt: Bool {
        return userDefaultsService.accountModuleSkipped
    }
}