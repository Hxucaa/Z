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

public final class SignUpViewModel {
    
    // MARK: Input
    
    // MARK: Output
    public let allInputsValid = MutableProperty<Bool>(false)
    
    // MARK: Variables
    public lazy var usernameAndPasswordViewModel: UsernameAndPasswordViewModel = { [unowned self] in
        let viewmodel = UsernameAndPasswordViewModel()
        
        self.allInputsValid <~ viewmodel.allInputsValid
        
        return viewmodel
    }()
    
    private let userService: IUserService
    
    // MARK: Actions
    public var signUp: SignalProducer<Bool, NSError> {
        return self.allInputsValid.producer
            // only allow TRUE value
            |> filter { $0 }
            |> flatMap(.Concat) { _ in combineLatest(self.usernameAndPasswordViewModel.username.producer, self.usernameAndPasswordViewModel.password.producer ) }
            |> promoteErrors(NSError)
            |> flatMap(FlattenStrategy.Merge) { username, password -> SignalProducer<Bool, NSError> in
                let user = User()
                user.username = username
                user.password = password
//                return self.userService.signUp(user)
                return SignalProducer<Bool, NSError> { sink, disposable in
                    sendNext(sink, true)
                }
        }
    }
    
    // MARK: Initializers
    public init(userService: IUserService) {
        self.userService = userService
        
    }
    
    // MARK: Setup
    
    // MARK: Others
}