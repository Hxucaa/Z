//
//  GenderPickerViewModel.swift
//  XListing
//
//  Created by Lance Zhu on 2015-08-06.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import ReactiveCocoa

public final class GenderPickerViewModel {
    
    // MARK: - Input
    public let gender = MutableProperty<Gender?>(nil)
    
    // MARK: - Output
    public let isGenderValid = MutableProperty<Bool>(false)
    
    // MARK: - Variables
    /// Signal containing a valid username
    public let validGenderSignal: SignalProducer<Gender, NoError>
    
    
    // MARK: - Initializers
    public init() {
        validGenderSignal = gender.producer
            .ignoreNil()

        isGenderValid <~ validGenderSignal
            .map { _ in true }
        
    }
    
    // MARK: - Setups
    
    // MARK: - Others
    
}