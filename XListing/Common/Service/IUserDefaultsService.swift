//
//  IUserDefaultsService.swift
//  XListing
//
//  Created by Lance Zhu on 2015-06-15.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import ReactiveCocoa

public protocol IUserDefaultsService : class {
    var accountModuleSkipped: Bool { get set }
    var firstLaunch: Bool { get set }
}