//
//  EventType.swift
//  XListing
//
//  Created by Lance Zhu on 2016-03-19.
//  Copyright © 2016 Lance Zhu. All rights reserved.
//

import Foundation

public enum EventType : Int, CustomStringConvertible {
    case Treat = 1
    case Split
    case ToGo
    
    public var description: String {
        switch self {
        case .Split:
            return "AA"
        case .Treat:
            return "请客"
        case .ToGo:
            return "想去"
        }
    }
}