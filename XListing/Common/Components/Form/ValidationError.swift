//
//  ValidationError.swift
//  XListing
//
//  Created by Hong Zhu on 2016-02-10.
//  Copyright © 2016 ZenChat. All rights reserved.
//

import Foundation


public enum ValidationError : ErrorType {
    case Required
    case Custom(message: String)
    
    public var description: String {
        switch self {
        case .Required:
            return "必填项目"
        case let .Custom(e):
            return e
        }
    }
}
