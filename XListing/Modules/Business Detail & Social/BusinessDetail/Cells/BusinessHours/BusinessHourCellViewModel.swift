////
////  BusinessHourCellViewModel.swift
////  XListing
////
////  Created by Lance Zhu on 2016-04-30.
////  Copyright (c) 2015 ZenChat. All rights reserved.
////
//
//import Foundation
//import ReactiveCocoa
//
//final class BusinessHourCellViewModel {
//    
//    // MARK: - Outputs
//    
//    var monHidden: AnyProperty<Bool> {
//        return AnyProperty(_monHidden)
//    }
//    var tuesHidden: AnyProperty<Bool> {
//        return AnyProperty(_tuesHidden)
//    }
//    var wedsHidden: AnyProperty<Bool> {
//        return AnyProperty(_wedsHidden)
//    }
//    var thursHidden: AnyProperty<Bool> {
//        return AnyProperty(_thursHidden)
//    }
//    var friHidden: AnyProperty<Bool> {
//        return AnyProperty(_friHidden)
//    }
//    var satHidden: AnyProperty<Bool> {
//        return AnyProperty(_satHidden)
//    }
//    var sunHidden: AnyProperty<Bool> {
//        return AnyProperty(_sunHidden)
//    }
//    
//    typealias DayStatus = (hidden: Bool, hours: String)
//    let monday: DayStatus
//    
//    // MARK: - Private
//    
//    let monHours: ConstantProperty<String>
//    private let _monHidden: MutableProperty<Bool>
//    let tuesHours: ConstantProperty<String>
//    private let _tuesHidden: MutableProperty<Bool>
//    let wedsHours: ConstantProperty<String>
//    private let _wedsHidden: MutableProperty<Bool>
//    let thursHours: ConstantProperty<String>
//    private let _thursHidden: MutableProperty<Bool>
//    let friHours: ConstantProperty<String>
//    private let _friHidden: MutableProperty<Bool>
//    let satHours: ConstantProperty<String>
//    private let _satHidden: MutableProperty<Bool>
//    let sunHours: ConstantProperty<String>
//    private let _sunHidden: MutableProperty<Bool>
//
//    // MARK: - Initializer
//    
//    init() {
//        
//        //get current day of the Week
//        let weekday = NSCalendar.currentCalendar().components(.Weekday, fromDate: NSDate()).weekday
//        
//        //set all days to hidden initially
//        _sunHidden = MutableProperty(true)
//        _monHidden = MutableProperty(true)
//        _tuesHidden = MutableProperty(true)
//        _wedsHidden = MutableProperty(true)
//        _thursHidden = MutableProperty(true)
//        _friHidden = MutableProperty(true)
//        _satHidden = MutableProperty(true)
//        
//        //show only the hours for the current day initially
//        switch weekday {
//            case 1: _sunHidden.value = false
//            case 2: _monHidden.value = false
//            case 3: _tuesHidden.value = false
//            case 4: _wedsHidden.value = false
//            case 5: _thursHidden.value = false
//            case 6: _friHidden.value = false
//            case 7: _satHidden.value = false
//            default: SBLogError("error getting current weekday")
//        }
//        
//        // TODO: replace with data from lean cloud
//        monHours = ConstantProperty("星期一：10:30AM - 3:00PM  &  5:00PM - 11:00PM")
//        tuesHours = ConstantProperty("星期二：10:30AM - 3:00PM  &  5:00PM - 11:00PM")
//        wedsHours = ConstantProperty("星期三：10:30AM - 3:00PM  &  5:00PM - 11:00PM")
//        thursHours = ConstantProperty("星期四：10:30AM - 3:00PM  &  5:00PM - 11:00PM")
//        friHours = ConstantProperty("星期五：10:30AM - 3:00PM  &  5:00PM - 11:00PM")
//        satHours = ConstantProperty("星期六：10:30AM - 3:00PM  &  5:00PM - 11:00PM")
//        sunHours = ConstantProperty("星期日：10:30AM - 3:00PM  &  5:00PM - 11:00PM")
//        
//    }
//    
//    // MARK: - Other functions
//    
//    //flip the hidden state
//    func switchLabelState() {
//        _sunHidden.value = !_sunHidden.value
//        _monHidden.value = !_monHidden.value
//        _tuesHidden.value = !_tuesHidden.value
//        _wedsHidden.value = !_wedsHidden.value
//        _thursHidden.value = !_thursHidden.value
//        _friHidden.value = !_friHidden.value
//        _satHidden.value = !_satHidden.value
//    }
//}
