//
//  Activation.swift
//  XListing
//
//  Created by Lance Zhu on 2016-01-17.
//  Copyright © 2016 ZenChat. All rights reserved.
//

import Foundation

public enum Activation : BooleanType, Equatable {
    case Active
    case InActive
    
    init(_ value: BooleanType) {
        if value.boolValue {
            self = .Active
        }
        else {
            self = .InActive
        }
    }
    
    public var boolValue: Bool {
        switch self {
        case .Active: return true
        case .InActive: return false
        }
    }
}

public func == (lhs: Activation, rhs: Activation) -> Bool {
    switch (lhs, rhs) {
    case (.Active, .Active):
        return true
    case (.InActive, .InActive):
        return true
    default:
        return false
    }
}
