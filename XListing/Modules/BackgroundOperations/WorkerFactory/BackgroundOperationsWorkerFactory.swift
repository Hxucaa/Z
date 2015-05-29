//
//  BackgroundOperationsWorkerFactory.swift
//  XListing
//
//  Created by Lance Zhu on 2015-05-28.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation

public struct BackgroundOperationsWorkerFactory : IBackgroundOperationsWorkerFactory {
    
    private let userService: IUserService
    private let geoLocationService: IGeoLocationService
    private let keychainService: IKeychainService
    
    private let signUpAndLogInWorker: ISignUpAndLogInWorker
    
    public init(userService: IUserService, geoLocationService: IGeoLocationService, keychainService: IKeychainService) {
        self.userService = userService
        self.geoLocationService = geoLocationService
        self.keychainService = keychainService
        
        self.signUpAndLogInWorker = SignUpAndLogInWorker(userService: userService, keychainService: keychainService)
    }
    
    public func startSignUpAndLogInWorker() {
        signUpAndLogInWorker.logInOrsignUpInBackground()
    }
}