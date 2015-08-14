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

public final class LogInViewModel {
    
    // MARK: - Input
    public let username = MutableProperty<String?>(nil)
    public let password = MutableProperty<String?>(nil)
    
    // MARK: - Output
    public let isUsernameValid = MutableProperty<Bool>(false)
    public let isPasswordValid = MutableProperty<Bool>(false)
    public let allInputsValid = MutableProperty<Bool>(false)
    
    
    // MARK: - Variables
    private let userService: IUserService
    private weak var accountNavigator: IAccountNavigator!
    /// Signal containing a valid username
    private var validUsernameSignal: SignalProducer<String, NoError>!
    /// Signal containing a valid password
    private var validPasswordSignal: SignalProducer<String, NoError>!
    
    // MARK: - Initializers
    
    public init(accountNavigator: IAccountNavigator, userService: IUserService) {
        self.accountNavigator = accountNavigator
        self.userService = userService
        
        setupUsername()
        setupPassword()
        setupAllInputsValid()
    }
    
    deinit {
        // Dispose signals before deinit.
        AccountLogVerbose("LogIn View Model deinitializes.")
    }
    
    // MARK: - Setups
    
    private func setupUsername() {
        validUsernameSignal = username.producer
            |> ignoreNil
            // TODO: regex
            |> filter { count($0) > 0 }
            
        isUsernameValid <~ validUsernameSignal
            |> map { _ in true }
    }
    
    private func setupPassword() {
        validPasswordSignal = password.producer
            |> ignoreNil
            // TODO: regex
            |> filter { count($0) > 0 }
        
        isPasswordValid <~ validPasswordSignal
            |> map { _ in true }
    }
    
    private func setupAllInputsValid() {
        allInputsValid <~ combineLatest(isUsernameValid.producer, isPasswordValid.producer)
            |> map { $0.0 && $0.1 }
    }
    
    // MARK: - Others
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
    
    public func goToFeaturedModule(_ callback: (CompletionHandler? -> ())? = nil) {
        accountNavigator.goToFeaturedModule { handler in
            callback?(handler)
        }
    }
}
