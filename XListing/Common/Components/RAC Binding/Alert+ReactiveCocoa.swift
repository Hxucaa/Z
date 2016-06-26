//
//  Alert+ReactiveCocoa.swift
//  XListing
//
//  Created by Lance Zhu on 2016-03-31.
//  Copyright © 2016 Lance Zhu. All rights reserved.
//

import Foundation
import ReactiveCocoa
import Result

extension Signal where Error : INetworkError {
    
    /**
     Handles error event and presents an error view to the interface.
     
     The operator implicitly move execution to main thread.
     
     - parameter router: An instance of router.
     
     - returns: A signal of value that cannot fail.
     */
    @warn_unused_result(message="Did you forget to call `start` on the producer?")
    func presentErrorView(router: IRouter) -> Signal<Value, NoError> {
        return self
            .observeOn(UIScheduler())
            .flatMapError {
                router.presentError($0)
                return SignalProducer<Value, NoError>.empty
        }
    }
}

extension SignalProducer where Error : INetworkError {
    
    /**
     Handles error event and presents an error view to the interface.
     
     The operator implicitly move execution to main thread.
     
     - parameter router: An instance of router.
     
     - returns: A signal producer of value that cannot fail.
     */
    @warn_unused_result(message="Did you forget to call `start` on the producer?")
    func presentErrorView(router: IRouter) -> SignalProducer<Value, NoError> {
        return lift { $0.presentErrorView(router) }
    }
}