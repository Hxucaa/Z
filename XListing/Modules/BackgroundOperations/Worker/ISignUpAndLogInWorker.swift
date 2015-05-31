//
//  ISignUpAndLogInWorker.swift
//  XListing
//
//  Created by Lance Zhu on 2015-05-28.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation

public protocol ISignUpAndLogInWorker {
    init(userService: IUserService, keychainService: IKeychainService)
    func logInOrsignUpInBackground()
}