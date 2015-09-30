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
    
    public var shortBusinessHours: PropertyOf<String> {
        return PropertyOf(_shortBusinessHours)
    }
    private let _shortBusinessHours: MutableProperty<String>
    
    public var longBusinessHours: PropertyOf<String> {
        return PropertyOf(_longBusinessHours)
    }
    private let _longBusinessHours: MutableProperty<String>


    public init() {
            _shortBusinessHours = MutableProperty("今天：10:30AM - 3:00PM  &  5:00PM - 11:00PM")
        
            _longBusinessHours = MutableProperty("星期一：10:30AM - 3:00PM  &  5:00PM - 11:00PM\n星期一：10:30AM - 3:00PM  &  5:00PM - 11:00PM\n星期一：10:30AM - 3:00PM  &  5:00PM - 11:00PM\n星期一：10:30AM - 3:00PM  &  5:00PM - 11:00PM\n星期一：10:30AM - 3:00PM  &  5:00PM - 11:00PM\n星期一：10:30AM - 3:00PM  &  5:00PM - 11:00PM\n星期一：10:30AM - 3:00PM  &  5:00PM - 11:00PM")
        
        
    }
}