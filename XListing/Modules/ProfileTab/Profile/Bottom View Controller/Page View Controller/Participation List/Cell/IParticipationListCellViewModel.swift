//
//  IParticipationListCellViewModel.swift
//  XListing
//
//  Created by Lance Zhu on 2015-10-07.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import ReactiveCocoa

public protocol IParticipationListCellViewModel : class {
    
    // MARK: - Outputs
    
    var coverImage: AnyProperty<UIImage?> { get }
    var businessName: AnyProperty<String> { get }
    var city: AnyProperty<String> { get }
    var participation: AnyProperty<String> { get }
    var eta: AnyProperty<String?> { get }
}