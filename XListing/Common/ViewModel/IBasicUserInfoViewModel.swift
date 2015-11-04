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
    var profileImage: AnyProperty<UIImage?> { get }
    var nickname: AnyProperty<String> { get }
    var ageGroup: AnyProperty<String> { get }
    var horoscope: AnyProperty<String> { get }
    var status: AnyProperty<String> { get }
    var gender: AnyProperty<String> { get }
    var ageGroupBackgroundColor: AnyProperty<UIColor> { get }
}