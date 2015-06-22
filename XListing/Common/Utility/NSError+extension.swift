//
//  NSError+extension.swift
//  XListing
//
//  Created by Lance Zhu on 2015-06-21.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import AVOSCloud

/// All domains of NSError in the app
private let AllDomainErrors = [
    "AVOS Cloud Error Domain" : AVOSCloudErrors
]

/// Specific errors with messages for AVOSCloud
private let AVOSCloudErrors = [
    kAVErrorUsernameTaken : "用户名已被使用了😂"
]

extension NSError {
    
    /// Returns customized error message
    public var customErrorDescription: String {
        if let domainErrors = AllDomainErrors[self.domain], message = domainErrors[self.code] {
            return message
        }
        else {
            DDLogWarn("Domain specific error has not been implemented yet... [\(self.description)]")
            return self.localizedDescription
        }
    }
}