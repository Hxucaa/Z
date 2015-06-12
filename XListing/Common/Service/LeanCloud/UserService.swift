//
//  UserService.swift
//  XListing
//
//  Created by Lance Zhu on 2015-04-17.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import SwiftTask
import ReactiveCocoa

public final class UserService : IUserService {
    
    public func isLoggedInAlready() -> Bool {
        if let currentUser = currentUser() where currentUser.isAuthenticated() {
            return true
        }
        else {
            return false
        }
    }
    
    public func isLoggedInAlready() -> SignalProducer<Bool, NSError> {
        return SignalProducer { sink, disposable in
            if let currentUser = self.currentUser() where currentUser.isAuthenticated() {
                sendNext(sink, true)
                sendCompleted(sink)
            }
            else {
                sendNext(sink, false)
                sendCompleted(sink)
            }
        }
    }
    
    public func currentUser() -> User? {
        return User.currentUser()
    }
    
    public func currentUserSignal() -> SignalProducer<User, NSError> {
        return SignalProducer { sink, disposable in
            if let currentUser = User.currentUser() {
                sendNext(sink, currentUser)
                sendCompleted(sink)
            }
            else {
                sendError(sink, NSError(domain: "UserService", code: 899, userInfo: nil))
            }
        }
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
    
    public func signUpSignal(user: User) -> SignalProducer<Bool, NSError> {
        return SignalProducer { sink, disposable in
            user.signUpInBackgroundWithBlock { success, error -> Void in
                if error == nil {
                    sendNext(sink, success)
                    sendCompleted(sink)
                }
                else {
                    sendError(sink, error)
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
    
    public func logInSignal(username: String, password: String) -> SignalProducer<User, NSError> {
        return SignalProducer { sink, disposable in
            User.logInWithUsernameInBackground(username, password: password) { user, error -> Void in
                if error == nil {
                    sendNext(sink, user as! User)
                    sendCompleted(sink)
                }
                else {
                    sendError(sink, error)
                }
            }
        }
    }
    
    public func logOut() {
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
    
    public func save(user: User) -> Task<Int, Bool, NSError> {
        return Task<Int, Bool, NSError> { fulfill, reject -> Void in
            user.saveInBackgroundWithBlock { (success, error) -> Void in
                if error == nil {
                    fulfill(success)
                }
                else {
                    reject(error!)
                }
            }
        }
    }
    
    public func saveSignal<T: User>(user: T) -> SignalProducer<Bool, NSError> {
        return SignalProducer { sink, disposable in
            user.saveInBackgroundWithBlock { (success, error) -> Void in
                if error == nil {
                    sendNext(sink, success)
                }
                else {
                    sendError(sink, error)
                }
            }
        }
    }
}




















