//
//  FeaturedListBusinessCell_StatsViewModel.swift
//  XListing
//
//  Created by Lance Zhu on 2015-09-15.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import ReactiveCocoa

public final class FeaturedListBusinessCell_StatsViewModel : IFeaturedListBusinessCell_StatsViewModel {
    
    // MARK: - Inputs
    
    // MARK: - Outputs
    private let _treatCount: ConstantProperty<String>
    public var treatCount: PropertyOf<String> {
        return PropertyOf(_treatCount)
    }
    
    private let _aaCount: ConstantProperty<String>
    public var aaCount: PropertyOf<String> {
        return PropertyOf(_aaCount)
    }
    
    private let _toGoCount: ConstantProperty<String>
    public var toGoCount: PropertyOf<String> {
        return PropertyOf(_toGoCount)
    }
    
    // MARK: - Properties
    
    // MARK: - Initializers
    
    public init(treatCount: Int, aaCount: Int, toGoCount: Int) {
        _treatCount = ConstantProperty("AA \(treatCount)")
        _aaCount = ConstantProperty("请 \(aaCount)")
        _toGoCount = ConstantProperty("来 \(toGoCount)")
    }
    
    // MARK: - Setups
    
}