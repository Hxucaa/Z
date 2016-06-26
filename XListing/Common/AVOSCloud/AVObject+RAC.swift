//
//  AVObject+RAC.swift
//  XListing
//
//  Created by Lance Zhu on 2016-03-19.
//  Copyright © 2016 Lance Zhu. All rights reserved.
//

import Foundation
import ReactiveCocoa
import AVOSCloud

extension AVObject {
    
    /**
     Saves the AVObject asynchronously.
     
     - returns: SignalProducer sequence of operation status.
     */
    func rac_save() -> SignalProducer<Bool, NetworkError> {
        return SignalProducer { observer, disposable in
            self.saveInBackgroundWithBlock({ (success, error) -> Void in
                if error == nil {
                    observer.sendNext(success)
                    observer.sendCompleted()
                }
                else {
                    observer.sendFailed(error.toNetworkError())
                }
            })
        }
    }
    
    func rac_saveEventually() -> SignalProducer<Bool, NetworkError> {
        return SignalProducer { observer, disposable in
            self.saveEventually { (success, error) -> Void in
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
    
    /**
     Deletes the AVObject asynchronously
     
     - returns: SignalProducer sequence of operation status.
     */
    func rac_delete() -> SignalProducer<Bool, NetworkError> {
        return SignalProducer { observer, disposable in
            self.deleteInBackgroundWithBlock({ (success, error) -> Void in
                if error == nil {
                    observer.sendNext(success)
                    observer.sendCompleted()
                }
                else {
                    observer.sendFailed(error.toNetworkError())
                }
            })
        }
    }
    
    func rac_deleteEventually() -> SignalProducer<AVObject, NetworkError> {
        return SignalProducer { observer, disposable in
            self.deleteEventuallyWithBlock({ (result, error) -> Void in
                if error == nil {
                    observer.sendNext(result as! AVObject)
                    observer.sendCompleted()
                }
                else {
                    observer.sendFailed(error.toNetworkError())
                }
            })
        }
    }
    
    func rac_refresh() -> SignalProducer<AVObject, NetworkError> {
        return SignalProducer { observer, disposable in
            self.refreshInBackgroundWithBlock { (result, error) -> Void in
                if error == nil {
                    observer.sendNext(result)
                    observer.sendCompleted()
                }
                else {
                    observer.sendFailed(error.toNetworkError())
                }
            }
        }
    }
}
