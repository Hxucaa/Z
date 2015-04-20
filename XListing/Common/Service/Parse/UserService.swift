//
//  UserService.swift
//  XListing
//
//  Created by Lance Zhu on 2015-04-17.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import SwiftTask

public class UserService : ObjectService, IUserService {
    
    public func currentUser() -> UserDAO? {
        return UserDAO.currentUser()
    }
    
    public func signUp(user: UserDAO) -> Task<Int, Bool, NSError> {
        return Task<Int, Bool, NSError> { fulfill, reject -> Void in
            user.signUpInBackgroundWithBlock { success, error -> Void in
                if error == nil {
                    fulfill(success)
                }
                else {
                    reject(error!)
                }
            }
        }
    }
    
    public func logIn(username: String, password: String) -> Task<Int, UserDAO, NSError> {
        return Task<Int, UserDAO, NSError> { fulfill, reject -> Void in
            UserDAO.logInWithUsernameInBackground(username, password: password) { user, error -> Void in
                if error == nil {
                    fulfill(user as! UserDAO)
                }
                else {
                    reject(error!)
                }
            }
        }
    }
    
    public func logOut(user: UserDAO) -> Task<Int, Bool, NSError> {
        return Task<Int, Bool, NSError> { fulfill, reject -> Void in
            UserDAO.logOutInBackgroundWithBlock { error -> Void in
                if error == nil {
                    fulfill(true)
                }
                else {
                    reject(error!)
                }
            }
        }
    }
    
    public func logInAnonymously() -> Task<Int, UserDAO, NSError> {
        return Task<Int, UserDAO, NSError> { fulfill, reject -> Void in
            PFAnonymousUtils.logInWithBlock { user, error -> Void in
                if error == nil {
                    fulfill(user as! UserDAO)
                }
                else {
                    reject(error!)
                }
            }
        }
    }
}