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
    
    public func clearKeychain() throws {
        try Locksmith.deleteDataForUserAccount(account)
    }
    
    private func loadData() -> NSDictionary? {
        return Locksmith.loadDataForUserAccount(account)
    }
    
    private func saveData(dict: Dictionary<String, String>) throws {
        try Locksmith.saveData(dict, forUserAccount: account)
    }
    
    private func updateData(dict: Dictionary<String, String>) throws {
        try Locksmith.updateData(dict, forUserAccount: account)
    }
}
