//
//  KVO+extension.swift
//  XListing
//
//  Created by Lance Zhu on 2015-05-09.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import ReactKit

extension KVO {
    static func startingStringStream(target: NSObject, _ keyPath: String) -> Stream<NSString?> {
        return KVO.startingStream(target, keyPath)
            |> map { value -> NSString? in
                return value as? NSString
            }
    }
}