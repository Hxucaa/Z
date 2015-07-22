//
//  WarmSignalProducer.swift
//  XListing
//
//  Created by Lance Zhu on 2015-07-20.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import ReactiveCocoa

public struct WarmSignalProducer<Input, E: ErrorType> {
    
    /// Signal Producer type
    public typealias Producer = SignalProducer<Input, E>
    
    /// Observer type
    public typealias Sink = SinkOf<Event<Input, E>>
    
    private let signal: Signal<Input, E>
    
    /// The observer
    public let sink: Sink
    
    /// The signal producer
    public private(set) var producer: Producer!
    
    public init() {
        // create signal and its observer
        (signal, sink) = Signal<Input, E>.pipe()
        
        // create a signal producer
        producer = SignalProducer { observer, compositeDisposable in
            
            // bind signal to this signal producer and forward its events
            let disposable = self.signal
                |> observe(observer)
            
            // bind the life cycle of the signal to the signal producer
            compositeDisposable.addDisposable(disposable)
        }
    }
    
    /**
    Creates a SignalProducer that will be controller by sending events to the given observer (sink).
    
    The Signal will remain alive until a terminating event is sent to the observer.
    
    :returns: (SignalProducer<Input, E: ErrorType>, SinkOf<Event<Input, E>>)
    */
    public static func pipe() -> (Producer, Sink) {
        let signal = self()
        return (signal.producer, signal.sink)
    }
}