//
//  IUserService.swift
//  XListing
//
//  Created by Lance Zhu on 2015-04-17.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import SwiftTask
import ReactKit

public protocol IUserService {
    func isLoggedInAlready() -> Bool
    func currentUser() -> User?
    func signUp(user: User) -> Task<Int, Bool, NSError>
    func logIn(username: String, password: String) -> Task<Int, User, NSError>
    func logOut()
    func logInAnonymously() -> Task<Int, User, NSError>
    func save(user: User) -> Task<Int, Bool, NSError>
}