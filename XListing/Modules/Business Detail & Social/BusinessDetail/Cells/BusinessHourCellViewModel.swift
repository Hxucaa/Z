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
    
    // MARK: - Inputs
    
    // MARK: - Outputs
    
    public var monHours: AnyProperty<String> {
        return AnyProperty(_monHours)
    }
    public var monHidden: AnyProperty<Bool> {
        return AnyProperty(_monHidden)
    }
    
    public var tuesHours: AnyProperty<String> {
        return AnyProperty(_tuesHours)
    }
    public var tuesHidden: AnyProperty<Bool> {
        return AnyProperty(_tuesHidden)
    }
    
    public var wedsHours: AnyProperty<String> {
        return AnyProperty(_wedsHours)
    }
    public var wedsHidden: AnyProperty<Bool> {
        return AnyProperty(_wedsHidden)
    }
    
    public var thursHours: AnyProperty<String> {
        return AnyProperty(_thursHours)
    }
    public var thursHidden: AnyProperty<Bool> {
        return AnyProperty(_thursHidden)
    }
    
    public var friHours: AnyProperty<String> {
        return AnyProperty(_friHours)
    }
    public var friHidden: AnyProperty<Bool> {
        return AnyProperty(_friHidden)
    }
    
    public var satHours: AnyProperty<String> {
        return AnyProperty(_satHours)
    }
    public var satHidden: AnyProperty<Bool> {
        return AnyProperty(_satHidden)
    }
    
    public var sunHours: AnyProperty<String> {
        return AnyProperty(_sunHours)
    }
    public var sunHidden: AnyProperty<Bool> {
        return AnyProperty(_sunHidden)
    }
    
    // MARK: - Properties
    
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
        let weekday = NSCalendar.currentCalendar().components(.CalendarUnitWeekday, fromDate: NSDate()).weekday
        
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
    
    // MARK: - API
    
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