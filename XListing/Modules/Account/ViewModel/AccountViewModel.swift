//
//  LogInViewModel.swift
//  XListing
//
//  Created by Lance Zhu on 2015-04-23.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation

public class AccountViewModel : IAccountViewModel {
    
    private let userService: IUserService
    
    public init(userService: IUserService) {
        self.userService = userService
        if UserService.isLoggedInAlready() {
            println("User is already logged in!")
        }
        else {
            logIn("test1", password: "12345678")
        }
    }
    
    public func logIn(username: String, password: String) {
        userService.logIn(username, password: password)
            .success { user -> Void in
                println(user)
            }
            .failure { error, isCancelled -> Void in
                println(error)
            }
    }
}