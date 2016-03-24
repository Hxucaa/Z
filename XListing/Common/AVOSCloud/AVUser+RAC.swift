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

extension AVUser {
    
    func rac_signUp() -> SignalProducer<Bool, NetworkError> {
        return SignalProducer { observer, disposable in
            self.signUpInBackgroundWithBlock { (success, error) -> Void in
                if error == nil {
                    observer.sendNext(success)
                    observer.sendCompleted()
                }
                else {
                    observer.sendFailed(error.toNetworkError())
                }
            }
        }
    }
    
    
    func rac_updatePassword(oldPassword: String, newPassword: String) -> SignalProducer<AVUser, NetworkError> {
        return SignalProducer { observer, disposable in
            self.updatePassword(oldPassword, newPassword: newPassword) { (object, error) -> Void in
                if error == nil {
                    observer.sendNext(object as! AVUser)
                    observer.sendCompleted()
                }
                else {
                    observer.sendFailed(error.toNetworkError())
                }
            }
        }
    }
    
    class func rac_logInWithUsername(username: String, password: String) -> SignalProducer<AVUser, NetworkError> {
        return SignalProducer { observer, disposable in
            AVUser.logInWithUsernameInBackground(username, password: password, block: { (user, error) -> Void in
                if error == nil {
                    observer.sendNext(user)
                    observer.sendCompleted()
                }
                else {
                    observer.sendFailed(error.toNetworkError())
                }
            })
        }
    }
    
    
    class func rac_logInWithPhoneNumber(phoneNumber: String, password: String) -> SignalProducer<AVUser, NetworkError> {
        return SignalProducer { observer, disposable in
            AVUser.logInWithMobilePhoneNumberInBackground(phoneNumber, password: password, block: { (user, error) -> Void in
                if error == nil {
                    observer.sendNext(user)
                    observer.sendCompleted()
                }
                else {
                    observer.sendFailed(error.toNetworkError())
                }
            })
        }
    }
    
    class func rac_logInWithPhoneNumber(phoneNumber: String, smsCode: String) -> SignalProducer<AVUser, NetworkError> {
        return SignalProducer { observer, disposable in
            AVUser.logInWithMobilePhoneNumberInBackground(phoneNumber, smsCode: smsCode, block: { (user, error) -> Void in
                if error == nil {
                    observer.sendNext(user)
                    observer.sendCompleted()
                }
                else {
                    observer.sendFailed(error.toNetworkError())
                }
            })
        }
    }
    
    func rac_logOut() -> SignalProducer<Void, NetworkError> {
        return SignalProducer { observer, disposable in
            AVUser.logOut()
            
            observer.sendNext(())
            observer.sendCompleted()
        }
    }
}
