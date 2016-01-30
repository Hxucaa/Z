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
    
    // MARK: - Output
    public var areLogInInputsPresent: SignalProducer<Bool, NoError> {
        return usernameAndPasswordViewModel.allInputsValid.producer
    }
    
    // MARK: - Properties
    
    // MARK: - View Models
    public let usernameAndPasswordViewModel = UsernameAndPasswordViewModel()
    
    // MARK: - Services
    private let userService: IUserService
    private weak var accountNavigator: IAccountNavigator!
    
    // MARK: - Initializers
    
    public init(accountNavigator: IAccountNavigator, userService: IUserService) {
        self.accountNavigator = accountNavigator
        self.userService = userService
    }
    
    deinit {
        // Dispose signals before deinit.
        AccountLogVerbose("Log In View Model deinitializes.")
    }
    
    // MARK: - Setups
    
    // MARK: - Others
    public var logIn: SignalProducer<Bool, NSError> {
        
        return usernameAndPasswordViewModel.allInputsValid.producer
            // only allow TRUE value
            .filter { $0 }
            // combine the username and password into one signal
            .flatMap(.Concat) { _ in
                zip(self.usernameAndPasswordViewModel.validUsernameSignal, self.usernameAndPasswordViewModel.validPasswordSignal)
            }
            // promote to NSError
            .promoteErrors(NSError)
            // log in user
            .flatMap(FlattenStrategy.Merge) { username, password -> SignalProducer<User, NSError> in
                return self.userService.logIn(username, password: password)
            }
            .map { _ in
                return true
            }
    }
    
    public func finishModule(callback: (CompletionHandler? -> ())? = nil) {
        accountNavigator.finishModule { handler in
            callback?(handler)
        }
    }
}
