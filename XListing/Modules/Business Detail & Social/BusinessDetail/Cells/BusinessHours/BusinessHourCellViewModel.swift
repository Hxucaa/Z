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
    public var monHidden: PropertyOf<Bool> {
        return PropertyOf(_monHidden)
    }
    public var tuesHours: PropertyOf<String> {
        return PropertyOf(_tuesHours)
    }
    public var tuesHidden: PropertyOf<Bool> {
        return PropertyOf(_tuesHidden)
    }
    public var wedsHours: PropertyOf<String> {
        return PropertyOf(_wedsHours)
    }
    public var wedsHidden: PropertyOf<Bool> {
        return PropertyOf(_wedsHidden)
    }
    public var thursHours: PropertyOf<String> {
        return PropertyOf(_thursHours)
    }
    public var thursHidden: PropertyOf<Bool> {
        return PropertyOf(_thursHidden)
    }
    public var friHours: PropertyOf<String> {
        return PropertyOf(_friHours)
    }
    public var friHidden: PropertyOf<Bool> {
        return PropertyOf(_friHidden)
    }
    public var satHours: PropertyOf<String> {
        return PropertyOf(_satHours)
    }
    public var satHidden: PropertyOf<Bool> {
        return PropertyOf(_satHidden)
    }
    public var sunHours: PropertyOf<String> {
        return PropertyOf(_sunHours)
    }
    public var sunHidden: PropertyOf<Bool> {
        return PropertyOf(_sunHidden)
    }
    
    // MARK: - Private
    
    private let _monHours: MutableProperty<String>
    private let _monHidden: MutableProperty<Bool>
    private let _tuesHours: MutableProperty<String>
    private let _tuesHidden: MutableProperty<Bool>
    private let _wedsHours: MutableProperty<String>
    private let _wedsHidden: MutableProperty<Bool>
    private let _thursHours: MutableProperty<String>
    private let _thursHidden: MutableProperty<Bool>
    private let _friHours: MutableProperty<String>
    private let _friHidden: MutableProperty<Bool>
    private let _satHours: MutableProperty<String>
    private let _satHidden: MutableProperty<Bool>
    private let _sunHours: MutableProperty<String>
    private let _sunHidden: MutableProperty<Bool>

    // MARK: - Initializer
    
    public init() {
        
        //get current day of the Week
        let weekday = NSCalendar.currentCalendar().components(.Weekday, fromDate: NSDate()).weekday
        
        //set all days to hidden initially
        _sunHidden = MutableProperty(true)
        _monHidden = MutableProperty(true)
        _tuesHidden = MutableProperty(true)
        _wedsHidden = MutableProperty(true)
        _thursHidden = MutableProperty(true)
        _friHidden = MutableProperty(true)
        _satHidden = MutableProperty(true)
        
        //show only the hours for the current day initially
        switch(weekday) {
            case 1: _sunHidden.put(false)
            case 2: _monHidden.put(false)
            case 3: _tuesHidden.put(false)
            case 4: _wedsHidden.put(false)
            case 5: _thursHidden.put(false)
            case 6: _friHidden.put(false)
            case 7: _satHidden.put(false)
            default: SBLogError("error getting current weekday")
        }
        
        //TODO: replace with data from lean cloud
        _monHours = MutableProperty("星期一：10:30AM - 3:00PM  &  5:00PM - 11:00PM")
        _tuesHours = MutableProperty("星期二：10:30AM - 3:00PM  &  5:00PM - 11:00PM")
        _wedsHours = MutableProperty("星期三：10:30AM - 3:00PM  &  5:00PM - 11:00PM")
        _thursHours = MutableProperty("星期四：10:30AM - 3:00PM  &  5:00PM - 11:00PM")
        _friHours = MutableProperty("星期五：10:30AM - 3:00PM  &  5:00PM - 11:00PM")
        _satHours = MutableProperty("星期六：10:30AM - 3:00PM  &  5:00PM - 11:00PM")
        _sunHours = MutableProperty("星期日：10:30AM - 3:00PM  &  5:00PM - 11:00PM")
        
    }
    
    // MARK: - Other functions
    
    //flip the hidden state
    public func switchLabelState() {
        _sunHidden.put(!_sunHidden.value)
        _monHidden.put(!_monHidden.value)
        _tuesHidden.put(!_tuesHidden.value)
        _wedsHidden.put(!_wedsHidden.value)
        _thursHidden.put(!_thursHidden.value)
        _friHidden.put(!_friHidden.value)
        _satHidden.put(!_satHidden.value)
    }
}