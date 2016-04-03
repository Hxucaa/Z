//
//  IBasicBusinessInfoViewModel.swift
//  XListing
//
//  Created by Lance Zhu on 2016-01-18.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//


import Foundation
import ReactiveCocoa
    
public protocol IBasicBusinessInfoViewModel : class {
    
    // MARK: - Inputs
    
    // MARK: - Outputs
    
    var name: ConstantProperty<String> { get }
    var phone: ConstantProperty<String> { get }
    var email: ConstantProperty<String?> { get }
    var websiteUrl: ConstantProperty<NSURL?> { get }
    var district: ConstantProperty<String?> { get }
    var city: ConstantProperty<String> { get }
    var province: ConstantProperty<String> { get }
    var coverImageUrl: ConstantProperty<NSURL?> { get }
    var coverImage: AnyProperty<UIImage> { get }
//    var coverImageDataBase64: ConstantProperty<String> { get }
    var description: ConstantProperty<String?> { get }
    var aaCount: ConstantProperty<Int> { get }
    var treatCount: ConstantProperty<Int> { get }
    var toGoCount: ConstantProperty<Int> { get }
    var eta: AnyProperty<String?> { get }
    
    // MARK: - Initializers
    
    // MARK: - Actions
}