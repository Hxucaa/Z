//
//  UsernameAndPasswordViewModel.swift
//  XListing
//
//  Created by Lance Zhu on 2015-08-05.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import ReactiveCocoa

public final class UsernameAndPasswordViewModel {
    
    // MARK: - Input
    public let username = MutableProperty<String?>(nil)
    public let password = MutableProperty<String?>(nil)
    
    // MARK: - Output
    public let isUsernameValid = MutableProperty<Bool>(false)
    public let isPasswordValid = MutableProperty<Bool>(false)
    public let allInputsValid = MutableProperty<Bool>(false)
    
    // MARK: - Properties
    /// Signal containing a valid username
    public var validUsernameSignal: SignalProducer<String, NoError> {
        // only allow usernames with:
        // - between 3 and 30 characters
        // - letters, numbers, dashes, periods, and underscores only
        return username.producer
            .ignoreNil()
            .filter { self.testRegex($0, pattern: "^([a-zA-Z0-9]|[-._]){3,30}$") }
    }
    /// Signal containing a valid password
    public var validPasswordSignal: SignalProducer<String, NoError> {
        // only allow passwords with:
        // - more than 8 characters
        // - letters, numbers, and most standard symbols
        // - at least one number, capital letter, or special character
        return password.producer
            .ignoreNil()
            .filter { $0.characters.count > 0 }
        //            .filter { self.testRegex($0, pattern: "^(?=.*[a-z])((?=.*[A-Z])|(?=.*\\d)|(?=.*[~`!@#$%^&*()-_=+|?/:;]))[a-zA-Z\\d~`!@#$%^&*()-_=+|?/:;]{8,}$") }
    }
    
    // MARK: - Initializers
    public init() {
        
        isUsernameValid <~ validUsernameSignal
            .map { _ in true }
        
        
        isPasswordValid <~ validPasswordSignal
            .map { _ in true }
        
        
        
        allInputsValid <~ combineLatest(isUsernameValid.producer, isPasswordValid.producer)
            .map { $0.0 && $0.1 }
    }
    
    // MARK: - Setups
    
    
    // MARK: - API
    
    // MARK: - Others
    private func testRegex(input: String, pattern: String) -> Bool {
        if let regex = try? NSRegularExpression(pattern: pattern, options: []) {
            
            let match = regex.numberOfMatchesInString(input, options: [], range:NSMakeRange(0, input.characters.count))
            return match == 1
        }
        else {
            return false
        }
    }
}