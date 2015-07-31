//
//  IUserService.swift
//  XListing
//
//  Created by Lance Zhu on 2015-04-17.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import ReactiveCocoa

public protocol IUserService : class {
    func isLoggedInAlready() -> Bool
    func currentLoggedInUser() -> SignalProducer<User, NSError>
    func signUp<T: User>(user: T) -> SignalProducer<Bool, NSError>
    func logIn(username: String, password: String) -> SignalProducer<User, NSError>
    func logOut()
    func save<T: User>(user: T) -> SignalProducer<Bool, NSError>
}