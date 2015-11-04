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
    
    var businessName: PropertyOf<String> { get }
    var city: PropertyOf<String> { get }
    var eta: PropertyOf<String?> { get }
    var price: PropertyOf<Int?> { get }
    var district: PropertyOf<String> { get }
    
    // MARK: - Initializers
    
    init(geoLocationService: IGeoLocationService, businessName: String?, city: String?, district: String?, price: Int?, geolocation: Geolocation?)
}