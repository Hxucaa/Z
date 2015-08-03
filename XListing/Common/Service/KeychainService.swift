//
//  KeychainService.swift
//  XListing
//
//  Created by William Qi on 2015-05-24.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import Locksmith

private let account = "org.XListing.com"

public final class KeychainService : IKeychainService {
    
    public func clearKeychain() -> Bool {
        let t = Locksmith.deleteDataForUserAccount(account)
        return t != nil ? true : false
    }
    
    private func loadData() -> (NSDictionary?, NSError?) {
        return Locksmith.loadDataForUserAccount(account)
    }
    
    private func saveData(dict: Dictionary<String, String>) -> NSError? {
        return Locksmith.saveData(dict, forUserAccount: account)
    }
    
    private func updateData(dict: Dictionary<String, String>) -> NSError? {
        return Locksmith.updateData(dict, forUserAccount: account)
    }
}
