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

private let DefaultWIPMessage = "努力跑..."
private let DefaultSuccessMessage = "成功了！"
private let DefaultErrorMessage = "失败了..."
private let DefaultInterruptMessage = "中断了..."

public final class HUD {
    
    /**
    Show HUD.
    */
    public class func show() -> SignalProducer<Void, NoError> {
        return SignalProducer<Void, NoError> { sink, disposable in
            SVProgressHUD.show()
            sendNext(sink, ())
            sendCompleted(sink)
        }
    }
    
    /**
    Inject display of HUD as side effects.
    
    :param: message The work in progress message. Has a default implementation if you do not provide one.
    
    :returns: A SignalProducer which can be continued with the next function.
    */
    public class func showWithStatusMessage<T, E>(message: String? = DefaultWIPMessage) -> SignalProducer<T, E> -> SignalProducer<T, E> {
        return { producer in
            return producer
                |> on(
                    next: { value in
                        SVProgressHUD.showWithStatus(message!)
                    }
                )
        }
    }
    

    /**
    Dismiss the HUD on one of the four events: interrupted, error, completed, next. You can customize the status message for each event. Note that the error event takes a errorHandler closure which provides an error and expects to return a message string.
    
    :param: successMessage   Status message for success.
    :param: interruptedMessage Status message for interruption.
    :param: errorHandler       Error handler which provides the error and expects a message string.
    
    :returns: A SignalProducer which can be continued with the next function.
    */
    public class func dismissWithStatusMessage<T, E>(successMessage: String? = DefaultSuccessMessage, interruptedMessage: String? = DefaultInterruptMessage, errorHandler: (E -> String)? = { _ in DefaultErrorMessage }) -> SignalProducer<T, E> -> SignalProducer<T, E> {
        return { producer in
            return producer
                |> on(
//                    interrupted: { _ in
//                        SVProgressHUD.showInfoWithStatus(interruptedMessage)
//                    },
                    error: { error in
                        SVProgressHUD.showErrorWithStatus(errorHandler!(error))
                    },
                    completed: { _ in
                        SVProgressHUD.showSuccessWithStatus(successMessage)
                    },
                    next: { value in
                        SVProgressHUD.showSuccessWithStatus(successMessage)
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
    
    Subcribe to HUD disappear notification. Must manually dispose of this signal.
    
    :returns: A SignalProducer containing the statu message displayed by the HUD.
    */
    public class func didDissappearNotification() -> SignalProducer<String, NoError> {
        return notification(SVProgressHUDDidDisappearNotification)
            |> map { ($0.userInfo as! [String : String])[SVProgressHUDStatusUserInfoKey]! }
    }
    
    /**
    Subscribe to a touch down inside on the HUD.
    
    :returns: A SignalProducer.
    */
    public class func didTouchDownInsideNotification() -> SignalProducer<UIEvent, NoError> {
        return notification(SVProgressHUDDidTouchDownInsideNotification)
            |> map { $0.object as! UIEvent }
    }
    
    /// Dismiss the HUD.
    public class func dismiss() {
        SVProgressHUD.dismiss()
    }
    
    private class func notification(name: String) -> SignalProducer<NSNotification, NoError> {
        return NSNotificationCenter.defaultCenter().rac_notifications(name: name, object: nil)
    }
}