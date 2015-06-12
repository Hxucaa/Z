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

public final class AccountViewModel : NSObject, IAccountViewModel {
    
    // MARK: - Public
    
    public private(set) lazy var editProfileViewModel: EditProfileViewModel = EditProfileViewModel(userService: self.userService)
    public private(set) lazy var logInViewModel: LogInViewModel = LogInViewModel(userService: self.userService)
    public private(set) lazy var signUpViewModel: SignUpViewModel = SignUpViewModel(userService: self.userService)
    
    public required init(userService: IUserService, router: IRouter) {
        self.userService = userService
        self.router = router
        
        super.init()
    }
    
    public func pushFeaturedModule() {
        router.pushFeatured()
    }
    
    // MARK: - Private
    
    // MARK: Services
    private let userService: IUserService
    private let router: IRouter
}