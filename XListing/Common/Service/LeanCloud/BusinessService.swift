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
        return SignalProducer<[Business], NSError> { sink, disposable in
            query.findObjectsInBackgroundWithBlock { (object, error) -> Void in
                if error == nil {
                    sendNext(sink, object as! [Business])
                    sendCompleted(sink)
                }
                else {
                    sendError(sink, error)
                }
            }
        }
    }
    
    /**
        This function finds the BusinessDAO based on the query.

        :params: query A PFQuery.
        :returns: a Task containing the result DAO in optional.
    */
    public func getFirst(var query: AVQuery) -> SignalProducer<Business, NSError> {
        return SignalProducer { sink, disposable in
            query.getFirstObjectInBackgroundWithBlock { (object, error) -> Void in
                if error == nil {
                    sendNext(sink, object as! Business)
                    sendCompleted(sink)
                }
                else {
                    sendError(sink, error)
                }
            }
        }
    }
}