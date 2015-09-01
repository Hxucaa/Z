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
    
    public init(accountNavigator: IAccountNavigator, userService: IUserService) {
        self.accountNavigator = accountNavigator
        self.userService = userService
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
    
    public func skipAccountModule() {
        accountNavigator.skipAccount()
    }
    
    public var rePrompt: Bool {
        if let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate, rootViewController = appDelegate.window?.rootViewController where rootViewController is RootTabBarController {
            return true
        }
        else {
            return false
        }
    }
}