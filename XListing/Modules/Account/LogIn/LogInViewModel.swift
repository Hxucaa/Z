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

final class LogInViewModel : ILogInViewModel {
    
    // MARK: - Input
    
    // MARK: - Output
    
    // MARK: - Properties
    
    // MARK: - View Models
    let usernameAndPasswordViewModel = UsernameAndPasswordViewModel()
    
    // MARK: - Services
    private weak var router: IRouter!
    private let meRepository: IMeRepository
    
    // MARK: - Initializers
    
    init(dep: (router: IRouter, meRepository: IMeRepository)) {
        self.router = dep.router
        self.meRepository = dep.meRepository
    }
    
    deinit {
        // Dispose signals before deinit.
        AccountLogVerbose("Log In View Model deinitializes.")
    }
    
    // MARK: - Setups
    
    // MARK: - Others
    var logIn: SignalProducer<Bool, NetworkError> {
        
        return usernameAndPasswordViewModel.allInputsValid.producer
            // only allow TRUE value
            .filter { $0 }
            // combine the username and password into one signal
            .flatMap(.Concat) { _ in
                zip(self.usernameAndPasswordViewModel.username.producer.ignoreNil(), self.usernameAndPasswordViewModel.password.producer.ignoreNil())
            }
            // promote to NSError
            .promoteErrors(NetworkError)
            // log in user
            .flatMap(FlattenStrategy.Merge) { username, password in
                return self.meRepository.logIn(username, password: password)
            }
            .map { _ in
                return true
            }
    }
    
    func finishModule(callback: (CompletionHandler? -> ())? = nil) {
        router.finishModule { handler in
            callback?(handler)
        }
    }
}
