//
//  UserStatus.swift
//  XListing
//
//  Created by Lance Zhu on 2016-01-17.
//  Copyright © 2016 ZenChat. All rights reserved.
//

import Foundation

public enum UserStatus : Int {
    case NotRegistered = 0
    case Registered
    case Locked
    case ForgotPassword
    case Disable
}