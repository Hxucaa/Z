//
//  iKeychainService.swift
//  XListing
//
//  Created by William Qi on 2015-05-24.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import SwiftTask

public protocol IKeychainService {
    func loadData(account: String, service: String) -> (NSDictionary?, NSError?)
    func storeStringData(key: String, data: String, account: String, service: String) -> NSError?
}