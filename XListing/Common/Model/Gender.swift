//
//  Gender.swift
//  XListing
//
//  Created by Bruce Li on 2015-07-06.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation

public enum Gender : Printable {
    case Male
    case Female
    
    public var description: String {
        switch self {
        case .Male:
            return "男"
        case .Female:
            return "女"
        }
    }
    
    public var dbRepresentation: Bool {
        switch self {
        case .Male:
            return true
        case .Female:
            return false
        }
    }
}