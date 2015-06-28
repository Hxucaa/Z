//
//  UserDefaultsService.swift
//  XListing
//
//  Created by Lance Zhu on 2015-06-15.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import ReactiveCocoa

public final class UserDefaultsService : IUserDefaultsService {
    
    private enum Key : String {
        case SkipAccount = "SkipAccount"
        case FirstLaunch = "FirstLuanch"
    }
    
    private let userDefaults = NSUserDefaults.standardUserDefaults()
    
    public init() {
        
    }
    
    /// If user chose to skip the sign up/log in screens, set this key to true.
    /// Logging out should
    public var accountModuleSkipped: Bool {
        get {
            return userDefaults.boolForKey(Key.SkipAccount.rawValue)
        }
        set {
            userDefaults.setBool(newValue, forKey: Key.SkipAccount.rawValue)
        }
    }
    
    /// Key for whether this is the first time the app the launched.
    public var firstLaunch: Bool {
        get {
            return userDefaults.boolForKey(Key.FirstLaunch.rawValue)
        }
        set {
            userDefaults.setBool(newValue, forKey: Key.FirstLaunch.rawValue)
        }
    }
}