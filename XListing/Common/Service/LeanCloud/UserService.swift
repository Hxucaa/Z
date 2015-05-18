//
//  UserService.swift
//  XListing
//
//  Created by Lance Zhu on 2015-04-17.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import SwiftTask
import Locksmith

public class UserService : ObjectService, IUserService {
    
    public class func isLoggedInAlready() -> Bool {
        if let c = currentUser()?.username {
            return true
        }
        else {
            return false
        }
    }
    
    public class func isSignedUpAlready() -> Bool {
        let (usernameData, userError) = Locksmith.loadDataForUserAccount("XListingUser", inService: "XListing")
        let (passwordData, passError) = Locksmith.loadDataForUserAccount("XListingPassword", inService: "XListing")
        
        if usernameData != nil {
           return true
        } else {
            return false
        }
    }
    
    public class func currentUser() -> User? {
        return User.currentUser()
    }
    
    public func signUp(user: User) -> Task<Int, Bool, NSError> {
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
    
    public func logIn(username: String, password: String) -> Task<Int, User, NSError> {
        return Task<Int, User, NSError> { fulfill, reject -> Void in
            User.logInWithUsernameInBackground(username, password: password) { user, error -> Void in
                if error == nil {
                    fulfill(user as! User)
                }
                else {
                    reject(error!)
                }
            }
        }
    }
    
    public func logOut(user: User) {
        User.logOut()
    }
    
    public func logInAnonymously() -> Task<Int, User, NSError> {
        return Task<Int, User, NSError> { fulfill, reject -> Void in
            PFAnonymousUtils.logInWithBlock { user, error -> Void in
                if error == nil {
                    fulfill(user as! User)
                }
                else {
                    reject(error!)
                }
            }
        }
    }
}