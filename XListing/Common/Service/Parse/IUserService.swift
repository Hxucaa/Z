//
//  IUserService.swift
//  XListing
//
//  Created by Lance Zhu on 2015-04-17.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import SwiftTask

public protocol IUserService {
    static func isLoggedInAlready() -> Bool
    static func currentUser() -> UserDAO?
    func signUp(user: UserDAO) -> Task<Int, Bool, NSError>
    func logIn(username: String, password: String) -> Task<Int, UserDAO, NSError>
    func logOut(user: UserDAO) -> Task<Int, Bool, NSError>
    func logInAnonymously() -> Task<Int, UserDAO, NSError>
}