//
//  ParticipationType.swift
//  XListing
//
//  Created by Lance Zhu on 2015-06-13.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import AVOSCloud

public enum ParticipationType : Int, CustomStringConvertible {
    case AA = 2 // swiftlint:disable:this type_name
    case Treat = 1
    case ToGo = 0
    
    public var description: String {
        switch self {
        case .AA:
            return "AA"
        case .Treat:
            return "请客"
        case .ToGo:
            return "想去"
        }
    }
}