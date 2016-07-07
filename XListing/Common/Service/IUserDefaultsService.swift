//
//  IUserDefaultsService.swift
//  XListing
//
//  Created by Lance Zhu on 2015-06-15.
//  Copyright (c) 2016 Lance Zhu. All rights reserved.
//

import Foundation

public protocol IUserDefaultsService : class {
    var accountModuleSkipped: Bool { get set }
    var firstLaunch: Bool { get set }
}