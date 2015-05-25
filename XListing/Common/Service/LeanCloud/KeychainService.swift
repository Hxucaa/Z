//
//  KeychainService.swift
//  XListing
//
//  Created by William Qi on 2015-05-24.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import SwiftTask
import Locksmith

public class KeychainService : ObjectService, IKeychainService {
    public func loadData(account: String, service: String) -> (NSDictionary?, NSError?) {
        return Locksmith.loadDataForUserAccount(account, inService: service)
    }
    
    public func storeStringData(key: String, data: String, account: String, service: String) -> NSError? {
        return Locksmith.saveData([key: data], forUserAccount: account, inService: service)
    }
}
