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
    var profileImage: PropertyOf<UIImage?> { get }
    var nickname: PropertyOf<String> { get }
    var ageGroup: PropertyOf<String> { get }
    var horoscope: PropertyOf<String> { get }
    var status: PropertyOf<String> { get }
    var gender: PropertyOf<String> { get }
    var ageGroupBackgroundColor: PropertyOf<UIColor> { get }
}