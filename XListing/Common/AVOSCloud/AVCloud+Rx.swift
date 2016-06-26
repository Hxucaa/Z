//
//  AVCloud+Rx.swift
//  XListing
//
//  Created by Lance Zhu on 2016-04-02.
//  Copyright © 2016 Lance Zhu. All rights reserved.
//

import Foundation
import AVOSCloud
import RxSwift

extension AVCloud {
    class func rx_callFunction(function: String, withParameters parameters: [NSObject : AnyObject]?) -> Observable<[NSObject: AnyObject]> {
        return Observable.create { observer in
            AVCloud.callFunctionInBackground(function, withParameters: parameters) { (object, error) -> Void in
                if error == nil {
                    observer.on(.Next(object as! [NSObject: AnyObject]))
                    observer.on(.Completed)
                }
                else {
                    observer.on(.Error(error.toNetworkError()))
                }
            }
            
            return NopDisposable.instance
        }
    }
    
    class func rx_rpcFunction(function: String, withParameters parameters: AnyObject?) -> Observable<AnyObject> {
        return Observable.create { observer in
            
            AVCloud.rpcFunctionInBackground(function, withParameters: parameters, block: { (object, error) -> Void in
                if error == nil {
                    observer.on(.Next(object))
                    observer.on(.Completed)
                }
                else {
                    observer.on(.Error(error.toNetworkError()))
                }
            })
            
            return NopDisposable.instance
        }
    }
}
