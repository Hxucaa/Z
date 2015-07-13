//
//  LogInViewModel.swift
//  XListing
//
//  Created by Lance Zhu on 2015-04-23.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import ReactiveCocoa
import AVOSCloud

public struct AccountViewModel : IAccountViewModel {
    
    // MARK: - Public
    
    public private(set) lazy var editProfileViewModel: EditProfileViewModel = EditProfileViewModel(userService: self.userService, router: self.router)
    public private(set) lazy var logInViewModel: LogInViewModel = LogInViewModel(userService: self.userService, router: self.router)
    public private(set) lazy var signUpViewModel: SignUpViewModel = SignUpViewModel(userService: self.userService)
    public private(set) lazy var landingPageViewModel: LandingPageViewModel = LandingPageViewModel(userDefaultsService: self.userDefaultsService, router: self.router)
    
    public init(userService: IUserService, router: IRouter, userDefaultsService: IUserDefaultsService) {
        self.userService = userService
        self.router = router
        self.userDefaultsService = userDefaultsService
    }
    
    public func pushFeaturedModule() {
        router.pushFeatured()
    }
    
    public func skipAccount(dismiss: () -> ()) {
        // if accountModuleSkipped is true, then this function has been called from other module. Call dismiss function to dismiss the current view.
        if userDefaultsService.accountModuleSkipped {
            dismiss()
        }
            // else it must be the first time the app is run on device. Go straight to featured list.
        else {
            router.pushFeatured()
            userDefaultsService.accountModuleSkipped = true
        }
    }
    
    // MARK: - Private
    
    // MARK: Services
    private let userService: IUserService
    private let router: IRouter
    private let userDefaultsService: IUserDefaultsService
}