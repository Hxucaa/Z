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
    
    private let WIPMessage = MutableProperty<String>(DefaultWIPMessage)
    private let SuccessMessage = MutableProperty<String>(DefaultSuccessMessage)
    private let ErrorMessage = MutableProperty<String>(DefaultErrorMessage)
    private let InterruptMessage = MutableProperty<String>(DefaultInterruptMessage)
    
    /**
    Show HUD.
    */
    public func show() -> SignalProducer<Void, NoError> {
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
    public func onShow<T, E>(message: String? = DefaultWIPMessage) -> SignalProducer<T, E> -> SignalProducer<T, E> {
        return { producer in
            return producer
                |> on(
                    next: { [unowned self] value in
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
    public func onDismiss<T, E>(successMessage: String? = DefaultSuccessMessage, interruptedMessage: String? = DefaultInterruptMessage, errorHandler: (E -> String)? = { _ in DefaultErrorMessage }) -> SignalProducer<T, E> -> SignalProducer<T, E> {
        return { producer in
            return producer
                |> on(interrupted: { _ in
                        self.WIPMessage.put(interruptedMessage!)
                        SVProgressHUD.showInfoWithStatus(interruptedMessage)
                    },
                    error: { error in
                        let message = errorHandler!(error)
                        self.ErrorMessage.put(message)
                        SVProgressHUD.showErrorWithStatus(message)
                    },
                    completed: { _ in
                        self.SuccessMessage.put(successMessage!)
                        SVProgressHUD.showSuccessWithStatus(successMessage)
                    },
                    next: { value in
                        self.SuccessMessage.put(successMessage!)
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
    
    Subcribe to HUD disappear notification. Must dispose of this signal.
    
    :param: interrupted Callback for Interruption.
    :param: error       Callback for Error.
    :param: completed   Callback For Completion.
    
    :returns: Disposable.
    */
    public func didDissappearNotification(#interrupted: ((String) -> ()), error: ((String) -> ()), completed: ((String) -> ())) -> Disposable {
        return notification(SVProgressHUDDidDisappearNotification)
            |> start(next: { notification in
                if let dict = notification.userInfo {
                    for (key, value) in dict {
                        if let value = value as? String {
                            switch(value) {
                            case self.SuccessMessage.value:
                                completed(value)
                            case self.ErrorMessage.value:
                                error(value)
                            case self.InterruptMessage.value:
                                interrupted(value)
                            default:
                                completed(value)
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
    public func didTouchDownInsideNotification(callback: () -> ()) -> Disposable {
        return notification(SVProgressHUDDidTouchDownInsideNotification)
            |> start(next: { notification in
                callback()
            })
    }
    
    private func notification(name: String) -> SignalProducer<NSNotification, NoError> {
        return NSNotificationCenter.defaultCenter().rac_notifications(name: name, object: nil)
    }
}