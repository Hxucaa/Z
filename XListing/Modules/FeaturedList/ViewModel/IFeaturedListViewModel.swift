//
//  IFeaturedListViewModel.swift
//  XListing
//
//  Created by Lance Zhu on 2015-04-08.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import SwiftTask
import ReactKit

public protocol IFeaturedListViewModel : class {
    init(navigator: INavigator, businessService: IBusinessService, userService: IUserService, geoLocationService: IGeoLocationService)
    var businessDynamicArr: DynamicArray { get }
    func getBusiness()
    func pushNearbyModule()
    func pushDetailModule(section: Int)
    func pushProfileModule()
    func presentAccountModule()
}