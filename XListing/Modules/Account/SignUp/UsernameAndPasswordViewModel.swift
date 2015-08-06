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
    
    // MARK: - Variables
    /// Signal containing a valid username
    private var validUsernameSignal: SignalProducer<String, NoError>!
    /// Signal containing a valid password
    private var validPasswordSignal: SignalProducer<String, NoError>!
    
    
    // MARK: - Initializers
    public init() {
        setupUsername()
        setupPassword()
        setupAllInputsValid()
    }
    
    // MARK: - Setups
    private func setupUsername() {
        // only allow usernames with:
        // - between 3 and 30 characters
        // - letters, numbers, dashes, periods, and underscores only
        validUsernameSignal = username.producer
            |> ignoreNil
            |> filter { self.testRegex($0, pattern: "^([a-zA-Z0-9]|[-._]){3,30}$") }
        
        isUsernameValid <~ validUsernameSignal
            |> map { _ in true }
    }
    
    private func setupPassword() {
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
    }
    
    private func setupAllInputsValid() {
        allInputsValid <~ combineLatest(isUsernameValid.producer, isPasswordValid.producer)
            |> map { $0.0 && $0.1 }
    }
    
    // MARK: - Others
    private func testRegex(input: String, pattern: String) -> Bool {
        let regex = NSRegularExpression(pattern: pattern, options: nil, error: nil)
        let matches = regex!.matchesInString(input, options: nil, range:NSMakeRange(0, count(input)))
        return matches.count == 1
    }
}