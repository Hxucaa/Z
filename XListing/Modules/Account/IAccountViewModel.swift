//
//  IAccountViewModel.swift
//  XListing
//
//  Created by Lance Zhu on 2015-04-23.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//
import ReactiveCocoa

public protocol IAccountViewModel : class {
    var editProfileViewModel: EditInfoViewModel { get }
    var logInViewModel: LogInViewModel { get }
    var signUpViewModel: SignUpViewModel { get }
    var landingPageViewModel: LandingPageViewModel { get }
    var gotoNextModuleCallback: (() -> ())? { get }
    init(userService: IUserService, router: IRouter, userDefaultsService: IUserDefaultsService, dismissCallback: (() -> ())?)
    func pushFeaturedModule()
    func skipAccount(dismiss: () -> ())
}