//
//  DetailParticipationViewModel.swift
//  XListing
//
//  Created by Lance Zhu on 2015-07-30.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import ReactiveCocoa

public final class DetailParticipationViewModel {
    
    // MARK: - Inputs
    
    // MARK: - Outputs
    public let count: ConstantProperty<String>
    
    // MARK: - Initializers
    public init(participationCount: Int) {
        count = ConstantProperty("(\(participationCount))")
        
    }
}