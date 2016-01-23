//
//  IBasicUserInfoViewModel.swift
//  XListing
//
//  Created by Lance Zhu on 2015-10-06.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import UIKit
import ReactiveCocoa

public protocol IBasicUserInfoViewModel : class {
    
    // MARK: - Outputs
    var coverPhoto: AnyProperty<UIImage?> { get }
    var coverPhotoUrl: SignalProducer<String?, NoError> { get }
    var nickname: SignalProducer<String, NoError> { get }
    var ageGroup: SignalProducer<String, NoError> { get }
    var horoscope: SignalProducer<String, NoError> { get }
    var whatsUp: SignalProducer<String?, NoError> { get }
    var gender: SignalProducer<String, NoError> { get }
    var ageGroupBackgroundColor: SignalProducer<UIColor, NoError> { get }
}