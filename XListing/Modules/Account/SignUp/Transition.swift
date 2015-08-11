//
//  Transition.swift
//  XListing
//
//  Created by Lance Zhu on 2015-08-06.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import UIKit
import ReactiveCocoa

public class TransitionManager {
    
    private let compositeDisposable = CompositeDisposable()
    private let (viewTransitionProducer, viewTransitionSink) = SignalProducer<TransitionActor, NoError>.buffer(0)
    private var currentIndex = -1
    private let initial: TransitionActor
    private let followUps: [TransitionActor]
    private let initialTransformation: (transition: TransitionActor) -> Void
    
    public init(initial: TransitionActor, followUps: [TransitionActor], initialTransformation: (transition: TransitionActor) -> Void, transformation: (current: TransitionActor, next: TransitionActor) -> Void) {
        
        self.initial = initial
        self.followUps = followUps
        self.initialTransformation = initialTransformation
        
        compositeDisposable += viewTransitionProducer
            // forwards events along with the previous value. The first member is the previous value and the second is the current value.
            |> combinePrevious(initial)
            |> start(next: { [weak self] current, next in
                transformation(current: current, next: next)
            })
    }
    
    deinit {
        compositeDisposable.dispose()
        DDLogVerbose("TransitionManager deinitializes.")
    }
    
    public func transitionNext() {
        assert(currentIndex < followUps.count - 1, "Cannot transition beyond the total number of follow up transitions defined!")
        sendNext(viewTransitionSink, followUps[++currentIndex])
    }
    
    public func installInitial() {
        initialTransformation(transition: initial)
    }
}

public class Transition<T: UIView> {
    public let view: T
    public private(set) var setup: (T -> Void)? = nil
    public private(set) var afterTransition: (T -> Void)? = nil
    public private(set) var cleanUp: (T -> Void)? = nil
    
    public init(view: T) {
        self.view = view
    }
    
    public init(view: T, setup: (T -> Void)? = nil, after: (T -> Void)? = nil, cleanUp: (T -> Void)? = nil) {
        self.view = view
        self.setup = setup
        self.afterTransition = after
        self.cleanUp = cleanUp
    }
    
    public var transitionActor: TransitionActor {
        return TransitionActor(view: view, setup: { self.setup?(self.view) }, afterTransition: { self.afterTransition?(self.view) }, cleanUp: { self.cleanUp?(self.view) })
    }
}

public class TransitionActor {
    public let view: UIView
    private var setup: (() -> ())? = nil
    private var afterTransition: (() -> ())? = nil
    private var cleanUp: (() -> ())? = nil
    
    public init(view: UIView, setup: (() -> ())? = nil, afterTransition: (() -> ())? = nil, cleanUp: (() -> ())? = nil) {
        self.view = view
        self.setup = setup
        self.afterTransition = afterTransition
        self.cleanUp = cleanUp
    }
    
    public func runSetup() {
        setup?()
    }
    
    public func runAfterTransition() {
        afterTransition?()
    }
    
    public func runCleanUp() {
        cleanUp?()
    }
}