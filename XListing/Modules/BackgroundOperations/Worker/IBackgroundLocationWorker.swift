//
//  IBackgroundLocationWorker.swift
//  XListing
//
//  Created by William Qi on 2015-06-13.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation

public protocol IBackgroundLocationWorker : class {
    init(userService: IUserService, userDefaultsService: IUserDefaultsService)
    func startLocationUpdates()
}