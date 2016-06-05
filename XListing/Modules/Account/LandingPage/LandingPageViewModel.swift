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

final class LandingPageViewModel : ILandingPageViewModel {
    
    // MARK: Services
    weak var router: IRouter!
    private let meRepository: IMeRepository
    
    init(meRepository: IMeRepository) {
        self.meRepository = meRepository
    }
    
    func goToSignUpComponent() {
        router.toSignUp()
    }
    
    func goToLogInComponent() {
        router.toLogIn()
    }
    
    func skipAccountModule() {
        router.skipAccount()
    }
    
    var rePrompt: Bool {
        if let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate, rootViewController = appDelegate.window?.rootViewController where rootViewController is RootTabBarController {
            return true
        }
        else {
            return false
        }
    }
}