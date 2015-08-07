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
    private var validBirthdaySignal: SignalProducer<NSDate, NoError>!
    
    
    // MARK: - Initializers
    public init() {
        setupNickname()
    }
    
    // MARK: - Setups
    private func setupNickname() {
        // only allow usernames with:
        // - between 3 and 30 characters
        // - letters, numbers, dashes, periods, and underscores only
//        validBirthdaySignal = nickname.producer
//            |> ignoreNil
//            |> filter { count($0) > 1 && count($0) <= 30 }
        
//        isBirthdayValid <~ validBirthdaySignal
//            |> map { _ in true }
    }
    
    // MARK: - Others
}