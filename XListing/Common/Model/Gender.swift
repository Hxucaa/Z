//
//  Gender.swift
//  XListing
//
//  Created by Lance Zhu on 2016-01-17.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation

public enum Gender : Int, CustomStringConvertible {
    case Male = 1
    case Female = 0
    
    public var description: String {
        switch self {
        case .Male: return "男"
        case .Female: return "女"
        }
    }
}