//
//  AgeGroup.swift
//  XListing
//
//  Created by Lance Zhu on 2015-09-17.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation

public enum AgeGroup : Int, Equatable, CustomStringConvertible {
//    case 70后 = 1, 75后, 80后, 85后, 90后, 95后, 00后, 05后
    case Group10 = 10
    case Group20 = 20
    case Group30 = 30
    case Group40 = 40
    case Group50 = 50
    case Group60 = 60
    case Group70 = 70
    case Group80 = 80
    case Group90 = 90
    case Group100 = 100
    case Group110 = 110
    case Group120 = 120
    
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