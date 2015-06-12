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
    var nearbyModuleNavigationNotificationSignal: Stream<NSNotification?>? { get }
    var profileModuleNavigationNotificationSignal: Stream<NSNotification?>? { get }
    var detailModuleNavigationNotificationSignal: Stream<NSNotification?>? { get }
    var accountModuleNavigationNotificationSignal: Stream<NSNotification?>? { get }
    
    func navigateToNearbyModule()
    func navigateToProfileModule()
    func navigateToDetailModule(data: [String: Business])
    func navigateToAccountModule()
}