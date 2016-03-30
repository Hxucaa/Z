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
private let DefaultFailedMessage = "失败了..."
private let DefaultInterruptMessage = "中断了..."

public class HUD {
    
    public enum DisappearStatus {
        case Normal, Interrupted
    }
    
    public init() {
        SVProgressHUD.setBackgroundColor(UIColor.x_HUDBackgroundColor())
        SVProgressHUD.setForegroundColor(UIColor.x_HUDForegroundColor())
        SVProgressHUD.setRingThickness(8.0)
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.Black)
        SVProgressHUD.setFont(UIFont.boldSystemFontOfSize(17.0))
    }
    
     /**
     Show HUD.
     
     - returns: A signal producer
     */
    public func show() -> SignalProducer<Void, NoError> {
        return SignalProducer<Void, NoError> { observer, disposable in
            SVProgressHUD.show()
            observer.sendNext(())
            observer.sendCompleted()
        }
    }
    
    /**
    Inject display of HUD as side effects.
    
    - parameter message: The work in progress message. Has a default implementation if you do not provide one.
    
    - returns: A SignalProducer which can be continued with the next function.
    */
    public func showWithStatusMessage<Value, Error>(message: String? = DefaultWIPMessage) -> SignalProducer<Value, Error> -> SignalProducer<Value, Error> {
        return { producer in
            return producer
                .on(
                    next: { value in
                        SVProgressHUD.showWithStatus(message!)
                    }
                )
        }
    }
    

    /**
    Dismiss the HUD on one of the four events: interrupted, error, completed, next. You can customize the status message for each event. Note that the error event takes a errorHandler closure which provides an error and expects to return a message string.
    
    - parameter successMessage:   Status message for success.
    - parameter interruptedMessage: Status message for interruption.
    - parameter failedHandler:       Failed handler which provides the error and expects a message string.
    
    - returns: A SignalProducer which can be continued with the next function.
    */
//    public class func dismissWithStatusMessage<Value, Error>(event: Event<successMessage: String? = DefaultSuccessMessage, interruptedMessage: String? = DefaultInterruptMessage, failedHandler: (Error -> String)? = { _ in DefaultFailedMessage }) {
////                    interrupted: { _ in
////                        SVProgressHUD.showInfoWithStatus(interruptedMessage)
////                    },
//                    failed: { error in
//                        SVProgressHUD.showErrorWithStatus(failedHandler!(error))
//                    },
//                    completed: { _ in
//                        SVProgressHUD.showSuccessWithStatus(successMessage)
//                    },
//                    next: { value in
//                        SVProgressHUD.showSuccessWithStatus(successMessage)
//                    }
//
//        }
//    }
    
     /**
     Dismiss HUD with failure message.
     
     - parameter failedMessage: Optional failure message.
     */
    public func dismissWithFailedMessage(failedMessage: String? = DefaultFailedMessage) {
        SVProgressHUD.showErrorWithStatus(failedMessage)
    }
    
    /**
     Dismiss HUD with interruption message.
     
     - parameter interruptedMessage: Optional interruption message.
     */
    public func dismissWithInterruptedMessage(interruptedMessage: String? = DefaultInterruptMessage) {
        SVProgressHUD.showInfoWithStatus(interruptedMessage)
    }
    
    /**
     Dismiss HUD with completion message.
     
     - parameter successMessage: Optional completion message.
     */
    public func dismissWithCompletedMessage(successMessage: String? = DefaultSuccessMessage) {
        SVProgressHUD.showSuccessWithStatus(successMessage)
    }
    
    /**
     Dismiss HUD with next message.
     
     - parameter successMessage: Optional next message.
     */
    public func dismissWithNextMessage(successMessage: String? = DefaultSuccessMessage) {
        SVProgressHUD.showSuccessWithStatus(successMessage)
    }
    
    /**
    
    Subcribe to HUD disappear notification. Must manually dispose of this signal.
    
    - returns: A SignalProducer containing the statu message displayed by the HUD.
    */
    public func didDissappearNotification() -> SignalProducer<DisappearStatus, NoError> {
        return notification(SVProgressHUDDidDisappearNotification)
            .map { notification -> DisappearStatus in
                if let userInfo = notification.userInfo as? [String : String], _ = userInfo[SVProgressHUDStatusUserInfoKey] {
                    return DisappearStatus.Normal
                }
                else {
                    return DisappearStatus.Interrupted
                }
            }
    }
    
    /**
    Subscribe to a touch down inside on the HUD.
    
    - returns: A SignalProducer.
    */
    public func didTouchDownInsideNotification() -> SignalProducer<UIEvent, NoError> {
        return notification(SVProgressHUDDidTouchDownInsideNotification)
            .map { $0.object as! UIEvent }
    }
    
    /// Dismiss the HUD.
    public func dismiss() {
        SVProgressHUD.dismiss()
    }
    
    private func notification(name: String) -> SignalProducer<NSNotification, NoError> {
        return NSNotificationCenter.defaultCenter().rac_notifications(name, object: nil)
    }
}