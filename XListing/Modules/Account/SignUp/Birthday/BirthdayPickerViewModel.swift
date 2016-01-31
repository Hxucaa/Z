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
    public var pickerUpperLimit: NSDate {
        return NSDate(timeInterval: -1, sinceDate: 年龄上限())
    }
    public var pickerLowerLimit: NSDate {
        return NSDate(timeInterval: 1, sinceDate: 年龄下限())
    }
    
    
    // MARK: - Variables
    
    // MARK: - Initializers
    public init() {

        isBirthdayValid <~ validBirthday()
            .map { _ in true }
        
        birthdayText <~ validBirthday()
            .map { date in
                let formatter = NSDateFormatter()
                formatter.locale = NSLocale(localeIdentifier: "zh_CN")
                formatter.dateStyle = NSDateFormatterStyle.LongStyle
                return formatter.stringFromDate(date)
            }
    }
    
    // MARK: - Setups
    
    // MARK: - Others
    private func 年龄上限() -> NSDate {
        let currentDate = NSDate()
        return calDate(currentDate, age: Constants.MIN_AGE)
    }
    
    private func 年龄下限() -> NSDate {
        let currentDate = NSDate()
        return calDate(currentDate, age: Constants.MAX_AGE)
    }
    
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
    
    /// Signal containing a valid username
    private func validBirthday() -> SignalProducer<NSDate, NoError> {
        return birthday.producer
            .ignoreNil()
            .filter { ($0.compare(self.年龄上限()) == .OrderedAscending) && ($0.compare(self.年龄下限()) == .OrderedDescending) }
    }
}