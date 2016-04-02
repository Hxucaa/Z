//
//  TypedAVQuery+RAC.swift
//  XListing
//
//  Created by Lance Zhu on 2016-03-19.
//  Copyright © 2016 ZenChat. All rights reserved.
//

import Foundation
import ReactiveCocoa
import AVOSCloud

class TypedAVQuery<T: AVObject> : AVQuery {
    
    init(query: AVQuery) {
        super.init(className: query.className)
    }
    
    func rac_findObjects() -> SignalProducer<[T], NetworkError> {
        
        return SignalProducer { observer, disposable in
            self.findObjectsInBackgroundWithBlock { (object, error) -> Void in
                if error == nil {
                    observer.sendNext(object as! [T])
                    observer.sendCompleted()
                }
                else {
                    observer.sendFailed(error.toNetworkError())
                }
            }
            
            disposable.addDisposable {
                self.cancel()
            }
        }
    }
    
    /**
     Gets an object asynchronously.
     
     - returns: SignalProducer sequence of the object.
     */
    func rac_getFirstObject() -> SignalProducer<T, NetworkError> {
        return SignalProducer { observer, disposable in
            self.getFirstObjectInBackgroundWithBlock { (object, error) -> Void in
                if error == nil {
                    observer.sendNext(object as! T)
                    observer.sendCompleted()
                }
                else {
                    observer.sendFailed(error.toNetworkError())
                }
            }
            
            disposable.addDisposable {
                self.cancel()
            }
        }
    }
    
    /**
     Counts objects asynchronously.
     
     - returns: SignalProducer sequence of the count.
     */
    func rac_countObjects() -> SignalProducer<Int, NSError> {
        return SignalProducer { observer, disposable in
            self.countObjectsInBackgroundWithBlock { (count, error) -> Void in
                if error == nil {
                    observer.sendNext(count)
                    observer.sendCompleted()
                }
                else {
                    observer.sendFailed(error)
                }
            }
            
            disposable.addDisposable {
                self.cancel()
            }
        }
    }
    
    /**
     Gets a AVObject based on objectId asynchronously.
     
     - parameter objectId: The id of the object being requested.
     
     - returns: SignalProducer sequence of the object.
     */
    func rac_getObjectWithId(objectId: String) -> SignalProducer<T, NSError> {
        return SignalProducer { observer, disposable in
            self.getObjectInBackgroundWithId(objectId) { (object, error) -> Void in
                if error == nil {
                    observer.sendNext(object as! T)
                    observer.sendCompleted()
                }
                else {
                    observer.sendFailed(error)
                }
            }
            
            disposable.addDisposable {
                self.cancel()
            }
        }
    }
    
    /**
     Remove all objects asynchronously.
     
     - returns: SignalProducer sequence of operation status.
     */
    func rac_deleteAll() -> SignalProducer<Bool, NSError> {
        return SignalProducer { observer, disposable in
            self.deleteAllInBackgroundWithBlock { (success, error) -> Void in
                if error == nil {
                    observer.sendNext(success)
                    observer.sendCompleted()
                }
                else {
                    observer.sendFailed(error)
                }
            }
            
            disposable.addDisposable {
                self.cancel()
            }
        }
    }
    
}

