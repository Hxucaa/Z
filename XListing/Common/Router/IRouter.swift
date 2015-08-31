//
//  IRouter.swift
//  XListing
//
//  Created by Lance on 2015-05-24.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation

public protocol IRouter {
    func pushNearby()
    func pushFeatured()
    func pushDetail<T: Business>(business: T)
    func pushAccount()
    func presentAccount(#completion: CompletionHandler?)
    func pushProfile()
    func pushWantToGo<T: Business>(business: T)
    func presentProfileEdit<T: User>(user: T, completion: CompletionHandler?)
    func pushSocialBusiness<T: Business>(business: T)
}