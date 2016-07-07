//
//  UserDefaultsService.swift
//  XListing
//
//  Created by Lance Zhu on 2015-06-15.
//  Copyright (c) 2016 Lance Zhu. All rights reserved.
//

import Foundation

public final class UserDefaultsService : IUserDefaultsService {
    
    private struct Key {
        static let SkipAccount = "SkipAccount"
        static let FirstLaunch = "FirstLuanch"
    }
    
    private let userDefaults = NSUserDefaults.standardUserDefaults()
    
    public init() {
        
    }
    
    /// If user chose to skip the sign up/log in screens, set this key to true.
    /// Logging out should
    public var accountModuleSkipped: Bool {
        get {
            return userDefaults.boolForKey(Key.SkipAccount)
        }
        set {
            userDefaults.setBool(newValue, forKey: Key.SkipAccount)
        }
    }
    
    /// Key for whether this is the first time the app the launched.
    public var firstLaunch: Bool {
        get {
            return userDefaults.boolForKey(Key.FirstLaunch)
        }
        set {
            userDefaults.setBool(newValue, forKey: Key.FirstLaunch)
        }
    }
}