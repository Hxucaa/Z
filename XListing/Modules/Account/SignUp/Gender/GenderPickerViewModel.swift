//
//  GenderPickerViewModel.swift
//  XListing
//
//  Created by Lance Zhu on 2015-08-06.
//  Copyright (c) 2016 Lance Zhu. All rights reserved.
//

import Foundation
import ReactiveCocoa

public final class GenderPickerViewModel {
    
    // MARK: - Input
    public let gender = MutableProperty<Gender?>(nil)
    
    // MARK: - Output
    public let isGenderValid = MutableProperty<Bool>(false)
    
    // MARK: - Variables
    
    
    // MARK: - Initializers
    public init() {
        isGenderValid <~ gender.producer
            .ignoreNil()
            .map { _ in true }
        
    }
    
    // MARK: - Setups
    
    // MARK: - Others
    
}