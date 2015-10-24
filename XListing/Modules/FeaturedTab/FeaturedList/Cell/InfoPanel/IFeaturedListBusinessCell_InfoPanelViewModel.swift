//
//  IFeaturedListBusinessCell_InfoPanelViewModel.swift
//  XListing
//
//  Created by Lance Zhu on 2015-09-15.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import ReactiveCocoa
import AVOSCloud

public protocol IFeaturedListBusinessCell_InfoPanelViewModel : class {
    var businessName: PropertyOf<String> { get }
    var city: PropertyOf<String> { get }
    var eta: PropertyOf<String?> { get }
    var price: PropertyOf<Int?> { get }
    var district: PropertyOf<String> { get }
    
    init(geoLocationService: IGeoLocationService, businessName: String?, city: String?, district: String?, price: Int?, geopoint: AVGeoPoint?)
}