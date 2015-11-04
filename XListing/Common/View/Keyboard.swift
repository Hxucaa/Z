//
//  Keyboard.swift
//  XListing
//
//  Created by Lance Zhu on 2015-07-21.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import ReactiveCocoa

public final class Keyboard {
    
    public static var willShowNotification: SignalProducer<NSNotification, NoError> {
        return notification(UIKeyboardWillShowNotification)
    }
    
    public static var didShowNotification: SignalProducer<NSNotification, NoError> {
        return notification(UIKeyboardDidShowNotification)
    }
    
    public static var willHideNotification: SignalProducer<NSNotification, NoError> {
        return notification(UIKeyboardWillHideNotification)
    }
    
    public static var didHideNotification: SignalProducer<NSNotification, NoError> {
        return notification(UIKeyboardDidHideNotification)
    }
    
    
    public static var afterKeyboardRetracted: SignalProducer<Void, NoError> {
        return didHideNotification
            .flatMap(.Latest) { notification -> SignalProducer<Void, NoError> in
                let userInfo = notification.userInfo as! [String : AnyObject]
                let animationDelay = userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSTimeInterval
                
                return SignalProducer<Void, NoError> { observer, disposable in
                        observer.sendNext(())
                        observer.sendCompleted()
                    }
                    // delay the signal due to the animation of retracting keyboard
                    // this cannot be executed on main thread, otherwise UI will be blocked
                    .delay(animationDelay, onScheduler: QueueScheduler())
                    // return the signal to main/ui thread in order to run UI related code
                    .observeOn(UIScheduler())
            }
    }
    
    private static func notification(name: String) -> SignalProducer<NSNotification, NoError> {
        return NSNotificationCenter.defaultCenter().rac_notifications(name, object: nil)
    }
}