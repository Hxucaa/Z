//
//  IAccountViewModel.swift
//  XListing
//
//  Created by Lance Zhu on 2015-04-23.
//  Copyright (c) 2016 Lance Zhu. All rights reserved.
//

import ReactiveCocoa

protocol ILandingPageViewModel : class {
    var rePrompt: Bool { get }
    
    func goToSignUpComponent()
    func goToLogInComponent()
    func skipAccountModule()
}