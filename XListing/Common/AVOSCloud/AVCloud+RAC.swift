//
//  AVCloud+RAC.swift
//  XListing
//
//  Created by Lance Zhu on 2016-03-23.
//  Copyright © 2016 Lance Zhu. All rights reserved.
//

import Foundation
import AVOSCloud
import ReactiveCocoa

extension AVCloud {
    class func rac_callFunction(function: String, withParameters parameters: [NSObject : AnyObject]?) -> SignalProducer<AnyObject, NetworkError> {
        return SignalProducer { observer, disposable in
            AVCloud.callFunctionInBackground(function, withParameters: parameters) { (object, error) -> Void in
                if error == nil {
                    observer.sendNext(object)
                    observer.sendCompleted()
                }
                else {
                    observer.sendFailed(error.toNetworkError())
                }
            }
        }
    }
    
    class func rac_rpcFunction(function: String, withParameters parameters: AnyObject?) -> SignalProducer<AnyObject, NetworkError> {
        return SignalProducer { observer, disposable in
            
            AVCloud.rpcFunctionInBackground(function, withParameters: parameters, block: { (object, error) -> Void in
                if error == nil {
                    observer.sendNext(object)
                    observer.sendCompleted()
                }
                else {
                    observer.sendFailed(error.toNetworkError())
                }
            })
        }
    }
}