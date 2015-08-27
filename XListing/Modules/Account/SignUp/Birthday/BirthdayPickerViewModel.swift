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
    public private(set) var 年龄上限: ConstantProperty<NSDate>!
    public private(set) var 年龄下限: ConstantProperty<NSDate>!
    public private(set) var pickerUpperLimit: ConstantProperty<NSDate>!
    public private(set) var pickerLowerLimit: ConstantProperty<NSDate>!
    
    // MARK: - Variables
    /// Signal containing a valid username
    public private(set) var validBirthdaySignal: SignalProducer<NSDate, NoError>!
    
    
    // MARK: - Initializers
    public init() {
        
        let currentDate = NSDate()
        年龄上限 = ConstantProperty<NSDate>(calDate(currentDate, age: Constants.MIN_AGE))
        年龄下限 = ConstantProperty<NSDate>(calDate(currentDate, age: Constants.MAX_AGE))
        pickerUpperLimit = ConstantProperty<NSDate>(NSDate(timeInterval: -1, sinceDate: 年龄上限.value))
        pickerLowerLimit = ConstantProperty<NSDate>(NSDate(timeInterval: 1, sinceDate: 年龄下限.value))
        
        validBirthdaySignal = birthday.producer
            |> ignoreNil
            |> validAgeOnly()

        isBirthdayValid <~ validBirthdaySignal
            |> map { _ in true }
        
        birthdayText <~ validBirthdaySignal
            |> map { date in
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
        let components = calendar.components(NSCalendarUnit.CalendarUnitDay | NSCalendarUnit.CalendarUnitMonth | NSCalendarUnit.CalendarUnitYear, fromDate: currentDate)
        let currentYear = components.year
        let currentMonth = components.month
        let currentDay = components.day
        
        let ageComponents = NSDateComponents()
        ageComponents.year = currentYear - age
        ageComponents.month = currentMonth
        ageComponents.day = currentDay
        return calendar.dateFromComponents(ageComponents)!
    }
    
    /**
    Check whether age is within the restriction
    
    :param: age The age
    
    :returns: Bool value indicating validity.
    */
    private func validAgeOnly<T: NSDate, E>() -> SignalProducer<T, E> -> SignalProducer<T, E> {
        return { producer in
            return producer
                |> filter { ($0.compare(self.年龄上限.value) == .OrderedAscending) && ($0.compare(self.年龄下限.value) == .OrderedDescending) }
        }
    }
}