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
    
    private var currentUser: User? {
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
        return SignalProducer { sink, disposable in
            if let currentUser = self.currentUser where currentUser.isAuthenticated() {
                sendNext(sink, true)
                sendCompleted(sink)
            }
            else {
                sendNext(sink, false)
                sendCompleted(sink)
            }
        }
    }
    
    public func currentLoggedInUser() -> SignalProducer<User, NSError> {
        return SignalProducer { sink, disposable in
            if let currentUser = self.currentUser where currentUser.isAuthenticated() {
//                let query = User.query()
//                query.getObjectInBackgroundWithId(currentUser.objectId)
                currentUser.fetchInBackgroundWithBlock { object, error -> Void in
                    if error == nil {
                        sendNext(sink, object as! User)
                        sendCompleted(sink)
                    }
                    else {
                        sendError(sink, error)
                    }
                }
            }
            else {
                sendError(sink, NSError(domain: "UserService", code: 899, userInfo: nil))
            }
        }
    }
    
    public func signUp<T: User>(user: T) -> SignalProducer<Bool, NSError> {
        return SignalProducer { sink, disposable in
            BOLogDebug("User created: \(user.toString())")
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
            |> on(completed: {
                LSLogVerbose("Sign up succeeded.")
            })
    }
    
    public func logIn(username: String, password: String) -> SignalProducer<User, NSError> {
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
    
    public func save<T: User>(user: T) -> SignalProducer<Bool, NSError> {
        return SignalProducer { sink, disposable in
            LSLogDebug("User profile created")
            if user.profileImg != nil{
            user.profileImg!.saveInBackgroundWithBlock{ (success, error) -> Void in
                if error == nil {
                    LSLogDebug("User image uploaded")
                    user.saveInBackgroundWithBlock { (success, error) -> Void in
                        if error == nil {
                            LSLogDebug("save profile return success")
                            sendNext(sink, success)
                        }
                        else {
                            sendError(sink, error)
                        }
                    }
                }
                else {
                    sendError(sink, error)
                }
            }
            }
        }
    }
}