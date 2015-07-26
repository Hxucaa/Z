//
//  IAccountViewModel.swift
//  XListing
//
//  Created by Lance Zhu on 2015-04-23.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//
import ReactiveCocoa

public protocol IAccountViewModel {
    var editProfileViewModel: EditInfoViewModel { mutating get }
    var logInViewModel: LogInViewModel { mutating get }
    var signUpViewModel: SignUpViewModel { mutating get }
    var landingPageViewModel: LandingPageViewModel { mutating get }
    var gotoNextModuleCallback: (() -> ())? { get }
    init(userService: IUserService, router: IRouter, userDefaultsService: IUserDefaultsService, dismissCallback: (() -> ())?)
    func pushFeaturedModule()
    func skipAccount(dismiss: () -> ())
}