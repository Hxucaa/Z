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
    
    var name: SignalProducer<String, NoError> { get }
    var phone: SignalProducer<String, NoError> { get }
    var email: SignalProducer<String?, NoError> { get }
    var websiteUrl: SignalProducer<String?, NoError> { get }
    var district: SignalProducer<String?, NoError> { get }
    var city: SignalProducer<String, NoError> { get }
    var province: SignalProducer<String, NoError> { get }
    var coverImageUrl: SignalProducer<String, NoError> { get }
    var coverImage: AnyProperty<UIImage> { get }
//    var coverImageDataBase64: SignalProducer<String, NoError> { get }
    var description: SignalProducer<String?, NoError> { get }
    var aaCount: SignalProducer<Int, NoError> { get }
    var treatCount: SignalProducer<Int, NoError> { get }
    var toGoCount: SignalProducer<Int, NoError> { get }
    var eta: AnyProperty<String?> { get }
    
    // MARK: - Initializers
    
    // MARK: - Actions
    func calculateEta() -> SignalProducer<NSTimeInterval, NSError>
    func fetchCoverImage() -> SignalProducer<UIImage, NSError>
}