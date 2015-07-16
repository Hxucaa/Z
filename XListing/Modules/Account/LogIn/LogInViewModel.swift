//
//  LogInViewModel.swift
//  XListing
//
//  Created by Lance Zhu on 2015-06-09.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import ReactiveCocoa
import AVOSCloud

public struct LogInViewModel {
    
    // MARK: - Public
    
    // MARK: Input
    public let username = MutableProperty<String>("")
    public let password = MutableProperty<String>("")
    
    // MARK: Output
    public let isUsernameValid = MutableProperty<Bool>(false)
    public let isPasswordValid = MutableProperty<Bool>(false)
    public let allInputsValid = MutableProperty<Bool>(false)
    
    // MARK: Actions
    public var logIn: SignalProducer<User, NSError> {
        
        return self.allInputsValid.producer
            // only allow TRUE value
            |> filter { $0 }
            // combine the username and password into one signal
            |> flatMap(.Concat) { _ in combineLatest(self.validUsernameSignal, self.validPasswordSignal) }
            // promote to NSError
            |> promoteErrors(NSError)
            // log in user
            |> flatMap(FlattenStrategy.Merge) { username, password -> SignalProducer<User, NSError> in
                return self.userService.logIn(username, password: password)
            }
    }
    
    // MARK: Initializers
    
    public init(userService: IUserService) {
        self.userService = userService
        
        setupUsername()
        setupPassword()
        setupAllInputsValid()
    }
    
    // MARK: - Private
    
    // MARK: Variables
    private let userService: IUserService
    /// Signal containing a valid username
    private var validUsernameSignal: SignalProducer<String, NoError>!
    /// Signal containing a valid password
    private var validPasswordSignal: SignalProducer<String, NoError>!
    
    
    // MARK: Setup
    
    private mutating func setupUsername() {
        validUsernameSignal = username.producer
            // TODO: regex
            |> filter { count($0) > 0 }
            
        isUsernameValid <~ validUsernameSignal
            |> map { _ in true }
    }
    
    private mutating func setupPassword() {
        validPasswordSignal = password.producer
            // TODO: regex
            |> filter { count($0) > 0 }
        
        isPasswordValid <~ validPasswordSignal
            |> map { _ in true }
    }
    
    private func setupAllInputsValid() {
        allInputsValid <~ combineLatest(isUsernameValid.producer, isPasswordValid.producer)
            |> map { $0.0 && $0.1 }
    }
}
