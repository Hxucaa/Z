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
    
    public var monHours: PropertyOf<String> {
        return PropertyOf(_monHours)
    }
    private let _monHours: MutableProperty<String>
    
    public var tuesHours: PropertyOf<String> {
        return PropertyOf(_tuesHours)
    }
    private let _tuesHours: MutableProperty<String>
    
    public var wedsHours: PropertyOf<String> {
        return PropertyOf(_wedsHours)
    }
    private let _wedsHours: MutableProperty<String>
    
    public var thursHours: PropertyOf<String> {
        return PropertyOf(_thursHours)
    }
    private let _thursHours: MutableProperty<String>
    
    public var friHours: PropertyOf<String> {
        return PropertyOf(_friHours)
    }
    private let _friHours: MutableProperty<String>
    
    public var satHours: PropertyOf<String> {
        return PropertyOf(_satHours)
    }
    private let _satHours: MutableProperty<String>
    
    public var sunHours: PropertyOf<String> {
        return PropertyOf(_sunHours)
    }
    private let _sunHours: MutableProperty<String>

    public init() {
        _monHours = MutableProperty("今天：10:30AM - 3:00PM  &  5:00PM - 11:00PM")
        _tuesHours = MutableProperty("今天：10:30AM - 3:00PM  &  5:00PM - 11:00PM")
        _wedsHours = MutableProperty("今天：10:30AM - 3:00PM  &  5:00PM - 11:00PM")
        _thursHours = MutableProperty("今天：10:30AM - 3:00PM  &  5:00PM - 11:00PM")
        _friHours = MutableProperty("今天：10:30AM - 3:00PM  &  5:00PM - 11:00PM")
        _satHours = MutableProperty("今天：10:30AM - 3:00PM  &  5:00PM - 11:00PM")
        _sunHours = MutableProperty("今天：10:30AM - 3:00PM  &  5:00PM - 11:00PM")
        
    }
}