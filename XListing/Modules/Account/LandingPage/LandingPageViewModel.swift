//
//  LandingPageViewModel.swift
//  XListing
//
//  Created by Lance Zhu on 2015-06-15.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import ReactiveCocoa

public final class LandingPageViewModel {
    
    // MARK: Properties
    private let userDefaultsService: IUserDefaultsService
    
    // MARK: - Initializers
    public init(userDefaultsService: IUserDefaultsService) {
        self.userDefaultsService = userDefaultsService
    }
    
    public var rePrompt: Bool {
        return userDefaultsService.accountModuleSkipped
    }
}