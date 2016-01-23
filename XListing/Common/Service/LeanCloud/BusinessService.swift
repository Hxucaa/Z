//
//  BusinessService.swift
//  XListing
//
//  Created by Lance Zhu on 2015-04-02.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import ReactiveCocoa
import AVOSCloud

public final class BusinessService : IBusinessService {
    
    public func findBy(query: AVQuery) -> SignalProducer<[Business], NSError> {
        return SignalProducer<[Business], NSError> { observer, disposable in
            query.findObjectsInBackgroundWithBlock { (object, error) -> Void in
                if error == nil {
                    observer.sendNext(object as! [Business])
                    observer.sendCompleted()
                }
                else {
                    observer.sendFailed(error)
                }
            }
        }
    }
    
    /**
     This function finds the BusinessDAO based on the query.

     - parameter query: A PFQuery.
     - returns: a Task containing the result DAO in optional.
     */
    public func getFirst(query: AVQuery) -> SignalProducer<Business, NSError> {
        return SignalProducer { observer, disposable in
            query.getFirstObjectInBackgroundWithBlock { (object, error) -> Void in
                if error == nil {
                    observer.sendNext(object as! Business)
                    observer.sendCompleted()
                }
                else {
                    observer.sendFailed(error)
                }
            }
        }
    }
}