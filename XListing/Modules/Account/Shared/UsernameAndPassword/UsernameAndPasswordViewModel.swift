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
    public private(set) var validUsernameSignal: SignalProducer<String, NoError>!
    /// Signal containing a valid password
    public private(set) var validPasswordSignal: SignalProducer<String, NoError>!
    public let submit: SignalProducer<Bool, NSError>
    
    // MARK: - Initializers
    public init(submit: SignalProducer<Bool, NSError>) {
        self.submit = submit
        
        // only allow usernames with:
        // - between 3 and 30 characters
        // - letters, numbers, dashes, periods, and underscores only
        validUsernameSignal = username.producer
            |> ignoreNil
            |> filter { self.testRegex($0, pattern: "^([a-zA-Z0-9]|[-._]){3,30}$") }
        
        isUsernameValid <~ validUsernameSignal
            |> map { _ in true }
        
        
        // only allow passwords with:
        // - more than 8 characters
        // - letters, numbers, and most standard symbols
        // - at least one number, capital letter, or special character
        validPasswordSignal = password.producer
            |> ignoreNil
            |> filter { count($0) > 0 }
        //            |> filter { self.testRegex($0, pattern: "^(?=.*[a-z])((?=.*[A-Z])|(?=.*\\d)|(?=.*[~`!@#$%^&*()-_=+|?/:;]))[a-zA-Z\\d~`!@#$%^&*()-_=+|?/:;]{8,}$") }
        
        isPasswordValid <~ validPasswordSignal
            |> map { _ in true }
        
        
        
        allInputsValid <~ combineLatest(isUsernameValid.producer, isPasswordValid.producer)
            |> map { $0.0 && $0.1 }
    }
    
    // MARK: - Setups
    
    
    // MARK: - API
    
    // MARK: - Others
    private func testRegex(input: String, pattern: String) -> Bool {
        if let regex = NSRegularExpression(pattern: pattern, options: nil, error: nil) {
            
            let match = regex.numberOfMatchesInString(input, options: nil, range:NSMakeRange(0, count(input)))
            return match == 1
        }
        else {
            return false
        }
    }
}