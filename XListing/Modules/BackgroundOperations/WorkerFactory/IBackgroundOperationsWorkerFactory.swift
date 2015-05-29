//
//  IBackgroundOperationsWorkerFactory.swift
//  XListing
//
//  Created by Lance Zhu on 2015-05-28.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation

public protocol IBackgroundOperationsWorkerFactory {
    init(userService: IUserService, geoLocationService: IGeoLocationService, keychainService: IKeychainService)
    func startSignUpAndLogInWorker()
}