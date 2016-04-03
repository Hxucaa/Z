//
//  ReactiveCocoa+extension.swift
//  XListing
//
//  Created by Lance Zhu on 2015-07-23.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import ReactiveCocoa
import Result

public extension SignalProducerType {
    /**
     Converts to a SignalProducer with `Void` value and `NoError`
     */
    @warn_unused_result(message="Did you forget to call `start` on the producer?")
    public func toNihil() -> SignalProducer<Void, NoError> {
        return self
            .map { _ in }
            .flatMapError { error in SignalProducer<Void, NoError>.empty }
    }
    
    /**
     Forwards events until the cell is being prepared for reuse.
     
     :param: view A UITableViewCell.
     */
    @warn_unused_result(message="Did you forget to call `start` on the producer?")
    public func takeUntilPrepareForReuse<U: UITableViewCell>(view: U) -> SignalProducer<Value, Error> {
        return self
            .takeUntil(view.rac_prepareForReuseSignal.toSignalProducer().toNihil())
    }
    
    /**
     Forwards events until the cell is being prepared for reuse.
     
     :param: view A UICollectionViewCell.
     */
    @warn_unused_result(message="Did you forget to call `start` on the producer?")
    public func takeUntilPrepareForReuse<U: UICollectionReusableView>(view: U) -> SignalProducer<Value, Error> {
        return self
            .takeUntil(view.rac_prepareForReuseSignal.toSignalProducer().toNihil())
    }
    
    /**
     Forwards events until the view is being prepared for reuse.
     
     :param: view A UICollectionViewCell.
     */
    @warn_unused_result(message="Did you forget to call `start` on the producer?")
    public func takeUntilPrepareForReuse<U: MKAnnotationView>(view: U) -> SignalProducer<Value, Error> {
        return self
            .takeUntil(view.rac_prepareForReuseSignal.toSignalProducer().toNihil())
    }
    
    /**
     Forwards events until the view controller will disappear.
     
     :param: view A UIViewController.
     */
    @warn_unused_result(message="Did you forget to call `start` on the producer?")
    public func takeUntilViewWillDisappear<U: UIViewController>(view: U) -> SignalProducer<Value, Error> {
        return self
            .takeUntil(view.rac_viewWillDisappear.toSignalProducer().toNihil())
    }
    
     /**
     Forwards events until the view is removed from the superview.
     
     - parameter view: The superview.
     
     - returns: A signal producer
     */
    @warn_unused_result(message="Did you forget to call `start` on the producer?")
    public func takeUntilRemoveFromSuperview<U: UIView>(view: U) -> SignalProducer<Value, Error> {
        return self.takeUntil(view.rac_removeFromSuperview.toSignalProducer().toNihil())
    }
    
    
    /**
     Log the life cycle of a signal, including `started`, `completed`, `interrupted`, `terminated`, and `disposed`.
     
     :param: module     The module which the signal is located at.
     :param: signalName Provide the name of the signal.
     
     :returns: Continue the signal.
     */
    @warn_unused_result(message="Did you forget to call `start` on the producer?")
    public func logLifeCycle(context: LogContext, signalName: String, file: StaticString = #file, function: StaticString = #function, line: UInt = #line) -> SignalProducer<Value, Error> {
        
        // use the appropriate method to log
        let log = { (context: LogContext, message: String) -> Void in
            switch context {
            case .LeanCloud: LSLogVerbose(message, file: file, function: function, line: line)
            case .Misc: MiscLogVerbose(message, file: file, function: function, line: line)
            case .Root: RootLogVerbose(message, file: file, function: function, line: line)
            case .BackgroundOp: BOLogVerbose(message, file: file, function: function, line: line)
            case .Account: AccountLogVerbose(message, file: file, function: function, line: line)
            case .Detail: DetailLogVerbose(message, file: file, function: function, line: line)
            case .Nearby: NearbyLogVerbose(message, file: file, function: function, line: line)
            case .Featured: FeaturedLogVerbose(message, file: file, function: function, line: line)
            case .Profile: ProfileLogVerbose(message, file: file, function: function, line: line)
            case .SocialBusiness: SBLogVerbose(message, file: file, function: function, line: line)
            case .UserProfile: UPLogVerbose(message, file: file, function: function, line: line)
            case .FullScreenImage: FSILogVerbose(message, file: file, function: function, line: line)
            case .Other: DDLogVerbose(message, file: file, function: function, line: line)
            }
        }
        
        return self
            .on(
                started: {
                    log(context, "`\(signalName)` signal started.")
                },
                completed: {
                    log(context, "`\(signalName)` signal completed.")
                },
                interrupted: {
                    log(context, "`\(signalName)` signal interrupted.")
                },
                terminated: {
                    log(context, "`\(signalName)` signal terminated.")
                },
                disposed: {
                    log(context, "`\(signalName)` signal disposed.")
                }
            )
    }
}

public extension Observer {
    
    /**
     Alias for `sendNext`.
     Puts a `Next` event into the given observer.

     - parameter value: A value.
     */
    public func proxyNext(value: Value) {
        self.sendNext(value)
    }
    
    /**
     Alias for `sendFailed`.
     Puts a `Failed` event into the given observer.
     
     - parameter error: An error object.
     */
    public func proxyFailed(error: Error) {
        self.sendFailed(error)
    }
    
    /**
     Alias for `sendCompleted`.
     Puts a `Completed` event into the given observer.
     */
    public func proxyCompleted() {
        self.sendCompleted()
    }
    
    /**
     Alias for `sendInterrupted`.
     Puts a `Interrupted` event into the given observer.
     */
    public func proxyInterrupted() {
        self.sendInterrupted()
    }
}


public typealias SimpleProxy = SignalProducer<Void, NoError>

extension SignalProducer {
    /**
     Create a buffer of size 0. Use this with `SimpleProxy`.
    
     - returns: A buffer of size 0.
     */
    internal static func proxy() -> (SignalProducer, Signal<Value, Error>.Observer) {
        return self.buffer(0)
    }
}