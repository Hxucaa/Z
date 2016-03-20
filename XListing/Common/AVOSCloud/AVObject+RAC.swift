//
//  AVObject+RAC.swift
//  XListing
//
//  Created by Lance Zhu on 2016-03-19.
//  Copyright © 2016 ZenChat. All rights reserved.
//

import Foundation
import ReactiveCocoa
import AVOSCloud

public extension AVObject {
    
    /**
     Saves the AVObject asynchronously.
     
     - returns: SignalProducer sequence of operation status.
     */
    public func rx_save() -> SignalProducer<Bool, NSError> {
        return SignalProducer { observer, disposable in
            self.saveInBackgroundWithBlock({ (success, error) -> Void in
                if error == nil {
                    observer.sendNext(success)
                    observer.sendCompleted()
                }
                else {
                    observer.sendFailed(error)
                }
            })
        }
    }
    
    public func rx_saveEventually() -> SignalProducer<Bool, NSError> {
        let t = AVError()
        return SignalProducer { observer, disposable in
            self.saveEventually { (success, error) -> Void in
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
    
    /**
     Deletes the AVObject asynchronously
     
     - returns: SignalProducer sequence of operation status.
     */
    public func rx_delete() -> SignalProducer<Bool, NSError> {
        return SignalProducer { observer, disposable in
            self.deleteInBackgroundWithBlock({ (success, error) -> Void in
                if error == nil {
                    observer.sendNext(success)
                    observer.sendCompleted()
                }
                else {
                    observer.sendFailed(error)
                }
            })
        }
    }
    
    public func rx_deleteEventually() -> SignalProducer<AVObject, NSError> {
        return SignalProducer { observer, disposable in
            self.deleteEventuallyWithBlock({ (result, error) -> Void in
                if error == nil {
                    observer.sendNext(result as! AVObject)
                    observer.sendCompleted()
                }
                else {
                    observer.sendFailed(error)
                }
            })
        }
    }
    
    public func rx_refresh() -> SignalProducer<AVObject, NSError> {
        return SignalProducer { observer, disposable in
            self.refreshInBackgroundWithBlock { (result, error) -> Void in
                if error == nil {
                    observer.sendNext(result)
                    observer.sendCompleted()
                }
                else {
                    observer.sendFailed(error)
                }
            }
        }
    }
}
