//
//  AVUser+RAC.swift
//  XListing
//
//  Created by Lance Zhu on 2016-03-19.
//  Copyright © 2016 ZenChat. All rights reserved.
//

import Foundation
import ReactiveCocoa
import AVOSCloud

public extension AVUser {
    
    public func rx_signUp() -> SignalProducer<Bool, NSError> {
        return SignalProducer { observer, disposable in
            self.signUpInBackgroundWithBlock { (success, error) -> Void in
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
    
    
    public func rx_updatePassword(oldPassword: String, newPassword: String) -> SignalProducer<AVUser, NSError> {
        return SignalProducer { observer, disposable in
            self.updatePassword(oldPassword, newPassword: newPassword) { (object, error) -> Void in
                if error == nil {
                    observer.sendNext(object as! AVUser)
                    observer.sendCompleted()
                }
                else {
                    observer.sendFailed(error)
                }
            }
        }
    }
    
    public class func rx_logInWithUsername(username: String, password: String) -> SignalProducer<AVUser, NSError> {
        return SignalProducer { observer, disposable in
            AVUser.logInWithUsernameInBackground(username, password: password, block: { (user, error) -> Void in
                if error == nil {
                    observer.sendNext(user)
                    observer.sendCompleted()
                }
                else {
                    observer.sendFailed(error)
                }
            })
        }
    }
    
    
    public class func rx_logInWithPhoneNumber(phoneNumber: String, password: String) -> SignalProducer<AVUser, NSError> {
        return SignalProducer { observer, disposable in
            AVUser.logInWithMobilePhoneNumberInBackground(phoneNumber, password: password, block: { (user, error) -> Void in
                if error == nil {
                    observer.sendNext(user)
                    observer.sendCompleted()
                }
                else {
                    observer.sendFailed(error)
                }
            })
        }
    }
    
    public class func rx_logInWithPhoneNumber(phoneNumber: String, smsCode: String) -> SignalProducer<AVUser, NSError> {
        return SignalProducer { observer, disposable in
            AVUser.logInWithMobilePhoneNumberInBackground(phoneNumber, smsCode: smsCode, block: { (user, error) -> Void in
                if error == nil {
                    observer.sendNext(user)
                    observer.sendCompleted()
                }
                else {
                    observer.sendFailed(error)
                }
            })
        }
    }
    
    public func rx_logOut() -> SignalProducer<Void, NSError> {
        return SignalProducer { observer, disposable in
            AVUser.logOut()
            
            observer.sendNext(())
            observer.sendCompleted()
        }
    }
}
