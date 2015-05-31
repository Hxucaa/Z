//
//  BackgroundOperationsWorkerFactory.swift
//  XListing
//
//  Created by Lance Zhu on 2015-05-28.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation

public struct BackgroundOperationsWorkerFactory : IBackgroundOperationsWorkerFactory {
    
    private let signUpAndLogInWorker: ISignUpAndLogInWorker
    
    public init() {
        let userService: IUserService = UserService()
        let geoLocationService: IGeoLocationService = GeoLocationService()
        let keychainService: IKeychainService = KeychainService()
        
        self.signUpAndLogInWorker = SignUpAndLogInWorker(userService: userService, keychainService: keychainService)
    }
    
    public func startSignUpAndLogInWorker() {
        signUpAndLogInWorker.logInOrsignUpInBackground()
    }
}