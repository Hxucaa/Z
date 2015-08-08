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
    public let birthday = MutableProperty<NSDate>(NSDate())
    
    // MARK: - Output
    public let isBirthdayValid = MutableProperty<Bool>(false)
    
    // MARK: - Variables
    /// Signal containing a valid username
    public let validBirthdaySignal: SignalProducer<NSDate, NoError>
    
    
    // MARK: - Initializers
    public init() {
        validBirthdaySignal = birthday.producer
//            |> filter { count($0) > 1 && count($0) <= 30 }

        isBirthdayValid <~ validBirthdaySignal
            |> map { _ in true }
    }
    
    // MARK: - Setups
    
    // MARK: - Others
}