//
//  IFeaturedListBusinessCell_InfoPanelViewModel.swift
//  XListing
//
//  Created by Lance Zhu on 2015-09-15.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import ReactiveCocoa

public protocol IFeaturedListBusinessCell_InfoPanelViewModel : class {
    var businessName: AnyProperty<String> { get }
    var city: AnyProperty<String> { get }
    var eta: AnyProperty<String?> { get }
    var price: AnyProperty<Int?> { get }
    var district: AnyProperty<String> { get }
    
    init(geoLocationService: IGeoLocationService, businessName: String?, city: String?, district: String?, price: Int?, geolocation: Geolocation?)
}