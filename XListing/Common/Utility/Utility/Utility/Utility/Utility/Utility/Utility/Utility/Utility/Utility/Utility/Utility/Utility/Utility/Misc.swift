//
//  Misc.swift
//  XListing
//
//  Created by Lance Zhu on 2015-08-02.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation

public func typeNameAndAddress<T: AnyObject>(object: T) -> String {
    return "<\(_stdlib_getDemangledTypeName(object)): \(unsafeAddressOf(object))>"
}