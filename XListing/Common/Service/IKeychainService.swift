//
//  iKeychainService.swift
//  XListing
//
//  Created by William Qi on 2015-05-24.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation

public protocol IKeychainService {
    func clearKeychain() -> Bool
}