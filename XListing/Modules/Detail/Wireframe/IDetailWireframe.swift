//
//  IDetailWireframe.swift
//  XListing
//
//  Created by Lance Zhu on 2015-04-15.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation

public protocol IDetailWireframe : class {
    init(rootWireframe: IRootWireframe, navigator: INavigator, wantToGoService: IWantToGoService, geoLocationService: IGeoLocationService)
}