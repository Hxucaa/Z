//
//  TypedAVQuery+Rx.swift
//  XListing
//
//  Created by Lance Zhu on 2016-04-02.
//  Copyright © 2016 ZenChat. All rights reserved.
//

import Foundation
import RxSwift
import AVOSCloud

class TypedAVQuery<T: AVObject> : AVQuery {
    
    init(query: AVQuery) {
        super.init(className: query.className)
    }
    
    func rx_findObjects() -> Observable<[T]> {
        
        return Observable.create { observer in
            self.findObjectsInBackgroundWithBlock { (object, error) -> Void in
                if error == nil {
                    observer.on(.Next(object as! [T]))
                    observer.on(.Completed)
                }
                else {
                    observer.on(.Error(error.toNetworkError()))
                }
            }
            
            return AnonymousDisposable {
                self.cancel()
            }
        }
    }
    
    /**
     Gets an object asynchronously.
     
     - returns: Observable sequence of the object.
     */
    func rx_getFirstObject() -> Observable<T> {
        return Observable.create { observer in
            self.getFirstObjectInBackgroundWithBlock { (object, error) -> Void in
                if error == nil {
                    observer.on(.Next(object as! T))
                    observer.on(.Completed)
                }
                else {
                    observer.on(.Error(error.toNetworkError()))
                }
            }
            
            return AnonymousDisposable {
                self.cancel()
            }
        }
    }
    
    /**
     Counts objects asynchronously.
     
     - returns: Observable sequence of the count.
     */
    func rx_countObjects() -> Observable<Int> {
        return Observable.create { observer in
            self.countObjectsInBackgroundWithBlock { (count, error) -> Void in
                if error == nil {
                    observer.on(.Next(count))
                    observer.on(.Completed)
                }
                else {
                    observer.on(.Error(error.toNetworkError()))
                }
            }
            
            return AnonymousDisposable {
                self.cancel()
            }
        }
    }
    
    /**
     Gets a AVObject based on objectId asynchronously.
     
     - parameter objectId: The id of the object being requested.
     
     - returns: Observable sequence of the object.
     */
    func rx_getObjectWithId(objectId: String) -> Observable<T> {
        return Observable.create { observer in
            self.getObjectInBackgroundWithId(objectId) { (object, error) -> Void in
                if error == nil {
                    observer.on(.Next(object as! T))
                    observer.on(.Completed)
                }
                else {
                    observer.on(.Error(error.toNetworkError()))
                }
            }
            
            return AnonymousDisposable {
                self.cancel()
            }
        }
    }
    
    /**
     Remove all objects asynchronously.
     
     - returns: Observable sequence of operation status.
     */
    func rx_deleteAll() -> Observable<Bool> {
        return Observable.create { observer in
            self.deleteAllInBackgroundWithBlock { (success, error) -> Void in
                if error == nil {
                    observer.on(.Next(success))
                    observer.on(.Completed)
                }
                else {
                    observer.on(.Error(error.toNetworkError()))
                }
            }
            
            return AnonymousDisposable {
                self.cancel()
            }
        }
    }
    
}


