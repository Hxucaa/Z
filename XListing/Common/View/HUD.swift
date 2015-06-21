//
//  HUD.swift
//  XListing
//
//  Created by Lance Zhu on 2015-06-10.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import SVProgressHUD
import ReactiveCocoa

private let WIPMessage = "努力跑..."
private let SuccessMessage = "成功了！"
private let ErrorMessage = "失败了..."
private let InterruptMessage = "中断了..."

public final class HUD {
    /**
    Show HUD.
    */
    public class func show() -> SignalProducer<Void, NoError> {
        return SignalProducer<Void, NoError> { sink, disposable in
            SVProgressHUD.show()
            sendNext(sink, ())
        }
    }
    
    /**
    Inject display of HUD as side effects.
    */
    public class func onShow<T, E>() -> SignalProducer<T, E> -> SignalProducer<T, E> {
        return { producer in
            return producer
                |> on(
                    next: { value in
                        SVProgressHUD.showWithStatus(WIPMessage)
                    }
                )
        }
    }
    
    /**
    Inject dismissal of HUD as side effects.
    */
    public class func onDismiss<T, E>() -> SignalProducer<T, E> -> SignalProducer<T, E> {
        return { producer in
            return producer
                |> on(interrupted: { _ in
                        SVProgressHUD.showInfoWithStatus(InterruptMessage)
                    },
                    error: { error in
                        SVProgressHUD.showErrorWithStatus(ErrorMessage)
                    },
                    completed: { _ in
                        SVProgressHUD.showSuccessWithStatus(SuccessMessage)
                    },
                    next: { value in
                        SVProgressHUD.showSuccessWithStatus(SuccessMessage)
                    }
                )

        }
    }
    
    public class var sharedInstance : HUD {
        struct Static {
            static var onceToken : dispatch_once_t = 0
            static var instance : HUD? = nil
        }
        dispatch_once(&Static.onceToken) {
            Static.instance = HUD()
        }
        return Static.instance!
    }
    
    public init() {
        SVProgressHUD.setBackgroundColor(UIColor.x_HUDBackgroundColor())
        SVProgressHUD.setForegroundColor(UIColor.x_HUDForegroundColor())
        SVProgressHUD.setRingThickness(8.0)
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.Black)
        SVProgressHUD.setFont(UIFont.boldSystemFontOfSize(17.0))
    }
    
    /**
    
    Subcribe to HUD disappear notification. Must dispose of this signal.
    
    :param: interrupted Callback for Interruption.
    :param: error       Callback for Error.
    :param: completed   Callback For Completion.
    
    :returns: Disposable.
    */
    public class func didDissappearNotification(#interrupted: (() -> ()), error: (() -> ()), completed: (() -> ())) -> Disposable {
        return notification(SVProgressHUDDidDisappearNotification)
            |> start(next: { notification in
                if let dict = notification.userInfo {
                    for (key, value) in dict {
                        if let value = value as? String {
                            switch(value) {
                            case SuccessMessage:
                                completed()
                            case ErrorMessage:
                                error()
                            case InterruptMessage:
                                interrupted()
                            default:
                                completed()
                            }
                        }
                    }
                    
                }
            })
    }
    
    /**
    Subscribe to a touch event on the HUD directly.
    
    :param: callback Callback.
    
    :returns: Disposable.
    */
    public class func didTouchDownInsideNotification(callback: () -> ()) -> Disposable {
        return notification(SVProgressHUDDidTouchDownInsideNotification)
            |> start(next: { notification in
                callback()
            })
    }
    
    private class func notification(name: String) -> SignalProducer<NSNotification, NoError> {
        return NSNotificationCenter.defaultCenter().rac_notifications(name: name, object: nil)
    }
}