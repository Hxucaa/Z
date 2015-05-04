//
//  NearbyInterfaceToDetailInterfaceDelegate.swift
//  XListing
//
//  Created by Lance Zhu on 2015-05-04.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation

public protocol NearbyInterfaceToDetailInterfaceDelegate : class {
    func transitionToDetailInterfaceFromNearbyInterface(businessViewModel: BusinessViewModel)
}