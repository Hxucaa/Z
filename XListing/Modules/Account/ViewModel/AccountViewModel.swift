//
//  LogInViewModel.swift
//  XListing
//
//  Created by Lance Zhu on 2015-04-23.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import SwiftTask
import ReactKit

public final class AccountViewModel : NSObject, IAccountViewModel {
    
    private let userService: IUserService
    
    public lazy var signUpViewModel: SignUpViewModel = SignUpViewModel(userService: self.userService)
    
    public lazy var logInViewModel: LogInViewModel = LogInViewModel(userService: self.userService)
    
    public required init(userService: IUserService) {
        self.userService = userService
        
        super.init()
    }
}