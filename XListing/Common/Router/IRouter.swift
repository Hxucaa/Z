//
//  IRouter.swift
//  XListing
//
//  Created by Lance on 2015-05-24.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import ReactKit

public protocol IRouter {
    func pushNearby()
    func pushFeatured()
    func pushDetail<T: Business>(business: T)
    func pushAccount()
    func presentAccount(#completion: CompletionHandler?)
    func pushProfile()
}