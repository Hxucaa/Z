//
//  SignUpViewModel.swift
//  XListing
//
//  Created by Lance Zhu on 2015-06-09.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import ReactiveCocoa
import AVOSCloud

public struct SignUpViewModel {
    
    // MARK: - Public
    
    // MARK: Input
    public let username = MutableProperty<String>("")
    public let password = MutableProperty<String>("")
    
    // MARK: Output
    public let isUsernameValid = MutableProperty<Bool>(false)
    public let isPasswordValid = MutableProperty<Bool>(false)
    public let allInputsValid = MutableProperty<Bool>(false)
    //    public private(set) var usernameValidSignal: SignalProducer<Bool, NoError>!
    //    public private(set) var passwordValidSignal: SignalProducer<Bool, NoError>!
    
    // MARK: Actions
    public var signUp: SignalProducer<Bool, NSError> {
        return self.allInputsValid.producer
            // only allow TRUE value
            |> filter { $0 }
            |> mapError { _ in NSError() }
            |> flatMap(FlattenStrategy.Merge) { valid -> SignalProducer<Bool, NSError> in
                let user = User()
                user.username = self.username.value
                user.password = self.password.value
                return self.userService.signUp(user)
        }
    }
    
    // MARK: Initializers
    public init(userService: IUserService) {
        self.userService = userService
        
        setupUsername()
        setupPassword()
        setupAllInputsValid()
    }
    
    // MARK: Services
    private let userService: IUserService
    
    // MARK: Setup
    
    private func setupUsername() {
        // only allow usernames with:
        // - between 3 and 30 characters
        // - letters, numbers, dashes, periods, and underscores only
        isUsernameValid <~ username.producer
            |> filter { self.testRegex($0, pattern: "^([a-zA-Z0-9]|[-._]){3,30}$") }
            |> map { _ in return true }
    }
    
    private func setupPassword() {
        // only allow passwords with:
        // - more than 8 characters
        // - letters, numbers, and most standard symbols
        // - at least one number, capital letter, or special character
        isPasswordValid <~ password.producer
            |> filter { self.testRegex($0, pattern: "^(?=.*[a-z])((?=.*[A-Z])|(?=.*\\d)|(?=.*[~`!@#$%^&*()-_=+|?/:;]))[a-zA-Z\\d~`!@#$%^&*()-_=+|?/:;]{8,}$") }
            |> map { _ in return true }
    }
    
    private func setupAllInputsValid() {
        allInputsValid <~ combineLatest(isUsernameValid.producer, isPasswordValid.producer)
            |> map { values -> Bool in
                return values.0 && values.1
        }
    }
    
    // MARK: Helpers
    private func testRegex(input: String, pattern: String) -> Bool {
        let regex = NSRegularExpression(pattern: pattern, options: nil, error: nil)
        let matches = regex!.matchesInString(input, options: nil, range:NSMakeRange(0, count(input)))
        return matches.count == 1
    }
}