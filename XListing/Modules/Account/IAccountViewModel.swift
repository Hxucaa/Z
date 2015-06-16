//
//  ILogInViewModel.swift
//  XListing
//
//  Created by Lance Zhu on 2015-04-23.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import ReactKit
import SwiftTask

public protocol IAccountViewModel {
    var editProfileViewModel: EditProfileViewModel { mutating get }
    var logInViewModel: LogInViewModel { mutating get }
    var signUpViewModel: SignUpViewModel { mutating get }
    var landingPageViewModel: LandingPageViewModel { mutating get }
    init(userService: IUserService, router: IRouter, userDefaultsService: IUserDefaultsService)
    func pushFeaturedModule()
}