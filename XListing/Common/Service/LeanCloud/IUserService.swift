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
    static func currentUser() -> User?
    func signUp(user: User) -> Task<Int, Bool, NSError>
    func logIn(username: String, password: String) -> Task<Int, User, NSError>
    func logOut(user: User)
    func logInAnonymously() -> Task<Int, User, NSError>
    static func updateBirthday(birthday: NSDate)
    static func getDisplayName() -> String
    static func updateDisplayName(displayName: String)
    static func updateProfilePicture(image: UIImage)
}