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
    
    var coverImage: PropertyOf<UIImage?> { get }
    var businessName: PropertyOf<String> { get }
    var city: PropertyOf<String> { get }
    var participation: PropertyOf<String> { get }
    var eta: PropertyOf<String?> { get }
}