//
//  AgeGroup.swift
//  XListing
//
//  Created by Lance Zhu on 2015-09-17.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation

public enum AgeGroup : Int, Equatable, CustomStringConvertible {
    case Group10 = 1
    case Group20
    case Group30
    case Group40
    case Group50
    case Group60
    case Group70
    case Group80
    case Group90
    case Group100
    case Group110
    case Group120
    
    public var description: String {
        switch self {
        case Group10: return "1910 后"
        case Group20: return "1920 后"
        case Group30: return "1930 后"
        case Group40: return "1940 后"
        case Group50: return "50 后"
        case Group60: return "60 后"
        case Group70: return "70 后"
        case Group80: return "80 后"
        case Group90: return "90 后"
        case Group100: return "00 后"
        case Group110: return "10 后"
        case Group120: return "20 后"
        }
    }
}