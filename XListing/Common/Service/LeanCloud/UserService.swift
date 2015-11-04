//
//  UserService.swift
//  XListing
//
//  Created by Lance Zhu on 2015-04-17.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import ReactiveCocoa
import AVOSCloud

public final class UserService : IUserService {
    
    public var currentUser: User? {
        return AVUser.currentUser() as? User
    }
    
    public func isLoggedInAlready() -> Bool {
        if let currentUser = currentUser where currentUser.isAuthenticated() {
            return true
        }
        else {
            return false
        }
    }
    
    public func isLoggedInAlready() -> SignalProducer<Bool, NSError> {
        return SignalProducer { observer, disposable in
            if let currentUser = self.currentUser where currentUser.isAuthenticated() {
                observer.sendNext(true)
                observer.sendCompleted()
            }
            else {
                observer.sendNext(false)
                observer.sendCompleted()
            }
        }
    }
    
    public func currentLoggedInUser() -> SignalProducer<User, NSError> {
        return SignalProducer { observer, disposable in
            if let currentUser = self.currentUser where currentUser.isAuthenticated() {
                currentUser.fetchInBackgroundWithBlock { object, error -> Void in
                    if error == nil {
                        observer.sendNext(object as! User)
                        observer.sendCompleted()
                    }
                    else {
                        sendError(observer, error)
                    }
                }
            }
            else {
                sendError(observer, NSError(domain: "UserService", code: 899, userInfo: nil))
            }
        }
    }
    
    public func signUp<T: User>(user: T) -> SignalProducer<Bool, NSError> {
        return SignalProducer { observer, disposable in
            LSLogDebug("User created: \(user.toString())")
            user.signUpInBackgroundWithBlock { success, error -> Void in
                if error == nil {
                    observer.sendNext(success)
                    observer.sendCompleted()
                }
                else {
                    sendError(observer, error)
                }
            }
        }
            .on(completed: {
                LSLogVerbose("Sign up succeeded.")
            })
    }
    
    public func logIn(username: String, password: String) -> SignalProducer<User, NSError> {
        return SignalProducer { observer, disposable in
            User.logInWithUsernameInBackground(username, password: password) { user, error -> Void in
                if error == nil {
                    observer.sendNext(user as! User)
                    observer.sendCompleted()
                }
                else {
                    sendError(observer, error)
                }
            }
        }
    }
    
    public func logOut() {
        User.logOut()
    }
    
    public func save<T: User>(user: T) -> SignalProducer<Bool, NSError> {
        return SignalProducer { observer, disposable in
            user.saveInBackgroundWithBlock { (success, error) -> Void in
                if error == nil {
                    observer.sendNext(success)
                    observer.sendCompleted()
                }
                else {
                    sendError(observer, error)
                }
            }
        }
    }
}