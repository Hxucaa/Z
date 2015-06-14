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
    private let backgroundLocationWorker: IBackgroundLocationWorker
    
    public init() {
        let userService: IUserService = UserService()
        let geoLocationService: IGeoLocationService = GeoLocationService()
        let keychainService: IKeychainService = KeychainService()
        
        self.signUpAndLogInWorker = SignUpAndLogInWorker(userService: userService, keychainService: keychainService)
        self.backgroundLocationWorker = BackgroundLocationWorker(userService: userService, geoService: geoLocationService)
    }
    
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
    
    public func startSignUpAndLogInWorker() {
        signUpAndLogInWorker.logInOrsignUpInBackground()
    }
    
    public func startBackgroundLocationWorker() {
        if (NSUserDefaults.standardUserDefaults().boolForKey("NotFirstLaunch")) {
            self.backgroundLocationWorker.startLocationUpdates()
        } else {
            delay(120) {
                self.backgroundLocationWorker.startLocationUpdates()
            }
        }
    }
}