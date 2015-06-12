//
//  IAccountWireframe.swift
//  XListing
//
//  Created by Lance Zhu on 2015-04-23.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation

public protocol IAccountWireframe : class {
    init(rootWireframe: IRootWireframe, router: IRouter, userService: IUserService)
}