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
    private let username = MutableProperty<String?>(nil)
    private let password = MutableProperty<String?>(nil)
    
    // MARK: - Output
    public let areLogInInputsPresent = MutableProperty<Bool>(false)
    
    // MARK: - View Models
    public lazy var usernameAndPasswordViewModel: UsernameAndPasswordViewModel = { [unowned self] in
        let viewmodel = UsernameAndPasswordViewModel(submit: self.logIn)
        
        self.username <~ viewmodel.validUsernameSignal
            |> map { Optional<String>($0) }
        
        self.password <~ viewmodel.validPasswordSignal
            |> map { Optional<String>($0) }
        
        return viewmodel
    }()
    
    
    // MARK: - Properties
    private let userService: IUserService
    private weak var accountNavigator: IAccountNavigator!
    private lazy var allLogInInputs: SignalProducer<(String, String), NoError> = combineLatest(self.username.producer |> ignoreNil, self.password.producer |> ignoreNil)
    
    // MARK: - Initializers
    
    public init(accountNavigator: IAccountNavigator, userService: IUserService) {
        self.accountNavigator = accountNavigator
        self.userService = userService
        
        
        areLogInInputsPresent <~ allLogInInputs
            |> map { _ in true }
    }
    
    deinit {
        // Dispose signals before deinit.
        AccountLogVerbose("Log In View Model deinitializes.")
    }
    
    // MARK: - Setups
    
    // MARK: - Others
    public var logIn: SignalProducer<Bool, NSError> {
        
        return self.areLogInInputsPresent.producer
            // only allow TRUE value
            |> filter { $0 }
            // combine the username and password into one signal
            |> flatMap(.Concat) { _ in self.allLogInInputs }
            // promote to NSError
            |> promoteErrors(NSError)
            // log in user
            |> flatMap(FlattenStrategy.Merge) { username, password -> SignalProducer<User, NSError> in
                return self.userService.logIn(username, password: password)
            }
            |> map { _ in
                return true
            }
    }
    
    public func goToFeaturedModule(_ callback: (CompletionHandler? -> ())? = nil) {
        accountNavigator.goToFeaturedModule { handler in
            callback?(handler)
        }
    }
}
