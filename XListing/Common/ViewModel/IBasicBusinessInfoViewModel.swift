//
//  IBasicBusinessInfoViewModel.swift
//  XListing
//
//  Created by Anson on 2015-10-24.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//


import Foundation
import ReactiveCocoa
    
public protocol IBasicBusinessInfoViewModel : class {
    
    // MARK: - Inputs
    
    // MARK: - Outputs
    
    var businessName: AnyProperty<String> { get }
    var city: AnyProperty<String> { get }
    var eta: AnyProperty<String?> { get }
    var price: AnyProperty<Int?> { get }
    var district: AnyProperty<String> { get }
    
    // MARK: - Initializers
    
    init(geoLocationService: IGeoLocationService, businessName: String?, city: String?, district: String?, price: Int?, geolocation: Geolocation?)
}