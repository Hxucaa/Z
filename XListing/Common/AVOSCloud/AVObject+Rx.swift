//
//  AVObject+Rx.swift
//  XListing
//
//  Created by Lance Zhu on 2016-04-02.
//  Copyright © 2016 ZenChat. All rights reserved.
//

import Foundation
import RxSwift
import AVOSCloud

extension AVObject {
    
    /**
     Saves the AVObject asynchronously.
     
     - returns: Observable sequence of operation status.
     */
    func rx_save() -> Observable<Bool> {
        return Observable.create { observer in
            self.saveInBackgroundWithBlock({ (success, error) -> Void in
                if error == nil {
                    observer.on(.Next(success))
                    observer.on(.Completed)
                }
                else {
                    observer.on(.Error(error.toNetworkError()))
                }
            })
            
            return NopDisposable.instance
        }
    }
    
    func rx_saveEventually() -> Observable<Bool> {
        return Observable.create { observer in
            self.saveEventually { (success, error) -> Void in
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
    
    /**
     Deletes the AVObject asynchronously
     
     - returns: Observable sequence of operation status.
     */
    func rx_delete() -> Observable<Bool> {
        return Observable.create { observer in
            self.deleteInBackgroundWithBlock({ (success, error) -> Void in
                if error == nil {
                    observer.on(.Next(success))
                    observer.on(.Completed)
                }
                else {
                    observer.on(.Error(error.toNetworkError()))
                }
            })
            
            return NopDisposable.instance
        }
    }
    
    func rx_deleteEventually() -> Observable<AVObject> {
        return Observable.create { observer in
            self.deleteEventuallyWithBlock({ (result, error) -> Void in
                if error == nil {
                    observer.on(.Next(result as! AVObject))
                    observer.on(.Completed)
                }
                else {
                    observer.on(.Error(error.toNetworkError()))
                }
            })
            
            return NopDisposable.instance
        }
    }
    
    func rx_refresh() -> Observable<AVObject> {
        return Observable.create { observer in
            self.refreshInBackgroundWithBlock { (result, error) -> Void in
                if error == nil {
                    observer.on(.Next(result))
                    observer.on(.Completed)
                }
                else {
                    observer.on(.Error(error.toNetworkError()))
                }
            }
            
            return NopDisposable.instance
        }
    }
}
