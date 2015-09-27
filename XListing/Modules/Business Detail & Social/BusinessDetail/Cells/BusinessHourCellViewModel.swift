//
//  BusinessHourCellViewModel.swift
//  XListing
//
//  Created by Bruce Li on 2015-09-27.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import ReactiveCocoa

public final class BusinessHourCellViewModel {
    
    // MARK: - Outputs
    
    public var businessHours: PropertyOf<String> {
        return PropertyOf(_businessHours)
    }
    
    private let _businessHours: MutableProperty<String>
    
    
    public var shouldExpandBusinessHours: MutableProperty<Bool>

    public init() {
        shouldExpandBusinessHours = MutableProperty(false)
        
        //if let businessHours = businessHours {
            _businessHours = MutableProperty("test business hours")
        //} else {
         //   _description = MutableProperty("")
        //}
        
    }
}