//
//  AVUser+Rx.swift
//  XListing
//
//  Created by Lance Zhu on 2016-04-02.
//  Copyright © 2016 ZenChat. All rights reserved.
//

import Foundation
import RxSwift
import AVOSCloud

extension AVUser {
    
    func rx_signUp() -> Observable<Bool> {
        return Observable.create { observer in
            self.signUpInBackgroundWithBlock { (success, error) -> Void in
                if error == nil {
                    observer.on(.Next(success))
                    observer.on(.Completed)
                }
                else {
                    observer.on(.Error(error.toNetworkError()))
                }
            }
            
            return NopDisposable.instance
        }
    }
    
    
    func rx_updatePassword(oldPassword: String, newPassword: String) -> Observable<AVUser> {
        return Observable.create { observer in
            self.updatePassword(oldPassword, newPassword: newPassword) { (object, error) -> Void in
                if error == nil {
                    observer.on(.Next(object as! AVUser))
                    observer.on(.Completed)
                }
                else {
                    observer.on(.Error(error.toNetworkError()))
                }
            }
            
            return NopDisposable.instance
        }
    }
    
    class func rx_logInWithUsername(username: String, password: String) -> Observable<AVUser> {
        return Observable.create { observer in
            AVUser.logInWithUsernameInBackground(username, password: password, block: { (user, error) -> Void in
                if error == nil {
                    observer.on(.Next(user))
                    observer.on(.Completed)
                }
                else {
                    observer.on(.Error(error.toNetworkError()))
                }
            })
            
            return NopDisposable.instance
        }
    }
    
    
    class func rx_logInWithPhoneNumber(phoneNumber: String, password: String) -> Observable<AVUser> {
        return Observable.create { observer in
            AVUser.logInWithMobilePhoneNumberInBackground(phoneNumber, password: password, block: { (user, error) -> Void in
                if error == nil {
                    observer.on(.Next(user))
                    observer.on(.Completed)
                }
                else {
                    observer.on(.Error(error.toNetworkError()))
                }
            })
            
            return NopDisposable.instance
        }
    }
    
    class func rx_logInWithPhoneNumber(phoneNumber: String, smsCode: String) -> Observable<AVUser> {
        return Observable.create { observer in
            AVUser.logInWithMobilePhoneNumberInBackground(phoneNumber, smsCode: smsCode, block: { (user, error) -> Void in
                if error == nil {
                    observer.on(.Next(user))
                    observer.on(.Completed)
                }
                else {
                    observer.on(.Error(error.toNetworkError()))
                }
            })
            
            return NopDisposable.instance
        }
    }
    
    func rx_logOut() -> Observable<Void> {
        return Observable.create { observer in
            AVUser.logOut()
            
            observer.on(.Next(()))
            observer.on(.Completed)
            
            return NopDisposable.instance
        }
    }
}

