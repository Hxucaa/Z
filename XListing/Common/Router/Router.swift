//
//  Router.swift
//  XListing
//
//  Created by Lance Zhu on 2015-05-08.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import ReactKit

public struct Router : IRouter {
    
    private class Token {}

    private struct Module {
        let token: AnyObject
        let name: String

        init(token: AnyObject, name: String) {
            self.token = token
            self.name = name
        }
    }
    
    private let nearbyModule: Module
    private let profileModule: Module
    private let detailModule: Module
    private let accountModule: Module
    
    public var nearbyModuleNavigationNotificationSignal: Stream<NSNotification?>?
    public var profileModuleNavigationNotificationSignal: Stream<NSNotification?>?
    public var detailModuleNavigationNotificationSignal: Stream<NSNotification?>?
    public var accountModuleNavigationNotificationSignal: Stream<NSNotification?>?

    public init() {
        nearbyModule = Module(token: Token(), name: "WillPushNearbyModuleNotification")
        profileModule = Module(token: Token(), name: "WillPushProfileModuleNotification")
        detailModule = Module(token: Token(), name: "WillPushDetailModuleNotification")
        accountModule = Module(token: Token(), name: "WillPushAccountModuleNotification")
        
        nearbyModuleNavigationNotificationSignal = Notification.stream(nearbyModule.name, nearbyModule.token)
        profileModuleNavigationNotificationSignal = Notification.stream(profileModule.name, profileModule.token)
        detailModuleNavigationNotificationSignal = Notification.stream(detailModule.name, detailModule.token)
        accountModuleNavigationNotificationSignal = Notification.stream(accountModule.name, accountModule.token)
    }
    
    private func postNotificationName(module: Module) {
        NSNotificationCenter.defaultCenter().postNotificationName(module.name, object: module.token)
    }
    
    private func postNotificationName(module: Module, userInfo: [String: Business]) {
        NSNotificationCenter.defaultCenter().postNotificationName(module.name, object: module.token, userInfo: userInfo)
    }
    
    public func navigateToNearbyModule() {
        postNotificationName(nearbyModule)
    }
    
    public func navigateToProfileModule() {
        postNotificationName(profileModule)
    }
    
    public func navigateToDetailModule(data: [String: Business]) {
        postNotificationName(detailModule, userInfo: data)
    }
    
    public func navigateToAccountModule() {
        postNotificationName(accountModule)
    }
}
