//
//  Transition.swift
//  XListing
//
//  Created by Lance Zhu on 2015-08-06.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import UIKit

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