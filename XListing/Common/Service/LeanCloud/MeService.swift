//
//  MeService.swift
//  XListing
//
//  Created by Hong Zhu on 2016-01-31.
//  Copyright © 2016 ZenChat. All rights reserved.
//

import Foundation
import ReactiveCocoa
import AVOSCloud

public struct UpdateMe {
    public var gender: Gender?
    public var birthday: NSDate?
    public var address: Address?
    public var coverPhoto: UIImage?
    public var whatsUp: String?
//    public var latestLocation: Geolocation?
    
}

public final class MeService : IMeService {
    
    public var currentUser: Me? {
        return AVUser.currentUser() as? Me
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
    
    public func currentLoggedInUser() -> SignalProducer<Me, NSError> {
        return SignalProducer { observer, disposable in
            if let currentUser = self.currentUser where currentUser.isAuthenticated() {
                currentUser.fetchInBackgroundWithBlock { object, error -> Void in
                    if error == nil {
                        observer.sendNext(object as! Me)
                        observer.sendCompleted()
                    }
                    else {
                        observer.sendFailed(error)
                    }
                }
            }
            else {
                observer.sendFailed(NSError(domain: "UserService", code: 899, userInfo: nil))
            }
        }
    }
    
    public func signUp(username: String, password: String, nickname: String, birthday: NSDate, gender: Gender, profileImage: UIImage) -> SignalProducer<Bool, NSError> {
        return SignalProducer { observer, disposable in
            let user = Me()
            
            user.username = username
            user.password = password
            user.nickname = nickname
            user.birthday = birthday
            let imageData = UIImagePNGRepresentation(profileImage)
            user.setCoverPhoto("profile.png", data: imageData!)
            user.gender = gender
            
            user.signUpInBackgroundWithBlock { success, error -> Void in
                if error == nil {
                    observer.sendNext(success)
                    observer.sendCompleted()
                }
                else {
                    observer.sendFailed(error)
                }
            }
            }
            .on(completed: {
                LSLogVerbose("Sign up succeeded.")
            })
    }
    
    public func logIn(username: String, password: String) -> SignalProducer<Me, NSError> {
        return SignalProducer { observer, disposable in
            User.logInWithUsernameInBackground(username, password: password) { user, error -> Void in
                if error == nil {
                    observer.sendNext(user as! Me)
                    observer.sendCompleted()
                }
                else {
                    observer.sendFailed(error)
                }
            }
        }
    }
    
    public func logOut() {
        User.logOut()
    }
    
//    public func update(
    
    
    public func save(user: Me) -> SignalProducer<Bool, NSError> {
        return SignalProducer { observer, disposable in
            user.saveInBackgroundWithBlock { (success, error) -> Void in
                if error == nil {
                    observer.sendNext(success)
                    observer.sendCompleted()
                }
                else {
                    observer.sendFailed(error)
                }
            }
        }
    }

}