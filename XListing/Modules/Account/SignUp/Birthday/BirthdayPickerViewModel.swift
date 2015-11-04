//
//  BirthdayPickerViewModel.swift
//  XListing
//
//  Created by Lance Zhu on 2015-08-06.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import ReactiveCocoa

public final class BirthdayPickerViewModel {
    
    // MARK: - Input
    public let birthday = MutableProperty<NSDate?>(nil)
    
    // MARK: - Output
    public let isBirthdayValid = MutableProperty<Bool>(false)
    public let birthdayText = MutableProperty<String?>(nil)
    public private(set) var pickerUpperLimit: ConstantProperty<NSDate>!
    public private(set) var pickerLowerLimit: ConstantProperty<NSDate>!
    
    // MARK: - Variables
    /// Signal containing a valid username
    public private(set) var validBirthdaySignal: SignalProducer<NSDate, NoError>!
    private var 年龄上限: NSDate!
    private var 年龄下限: NSDate!
    
    
    // MARK: - Initializers
    public init() {
        
        let currentDate = NSDate()
        年龄上限 = calDate(currentDate, age: Constants.MIN_AGE)
        年龄下限 = calDate(currentDate, age: Constants.MAX_AGE)
        pickerUpperLimit = ConstantProperty<NSDate>(NSDate(timeInterval: -1, sinceDate: 年龄上限))
        pickerLowerLimit = ConstantProperty<NSDate>(NSDate(timeInterval: 1, sinceDate: 年龄下限))
        
        validBirthdaySignal = birthday.producer
            .ignoreNil()
            .filter { ($0.compare(self.年龄上限) == .OrderedAscending) && ($0.compare(self.年龄下限) == .OrderedDescending) }

        isBirthdayValid <~ validBirthdaySignal
            .map { _ in true }
        
        birthdayText <~ validBirthdaySignal
            .map { date in
                let formatter = NSDateFormatter()
                formatter.locale = NSLocale(localeIdentifier: "zh_CN")
                formatter.dateStyle = NSDateFormatterStyle.LongStyle
                return formatter.stringFromDate(date)
            }
    }
    
    // MARK: - Setups
    
    // MARK: - Others
    private func calDate(currentDate: NSDate, age: Int) -> NSDate {
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([NSCalendarUnit.Day, NSCalendarUnit.Month, NSCalendarUnit.Year], fromDate: currentDate)
        let currentYear = components.year
        let currentMonth = components.month
        let currentDay = components.day
        
        let ageComponents = NSDateComponents()
        ageComponents.year = currentYear - age
        ageComponents.month = currentMonth
        ageComponents.day = currentDay
        return calendar.dateFromComponents(ageComponents)!
    }
}