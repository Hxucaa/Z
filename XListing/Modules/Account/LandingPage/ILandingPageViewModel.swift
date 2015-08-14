//
//  IAccountViewModel.swift
//  XListing
//
//  Created by Lance Zhu on 2015-04-23.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//
import ReactiveCocoa

public protocol ILandingPageViewModel : class {
    var rePrompt: Bool { get }
    init(accountNavigator: IAccountNavigator, userService: IUserService, userDefaultsService: IUserDefaultsService)
    func goToSignUpComponent()
    func goToLogInComponent()
    func skipAccountModule(dismiss: () -> ())
}