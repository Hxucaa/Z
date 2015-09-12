//
//  SocialBusiness_UtilityHeaderView.swift
//  XListing
//
//  Created by Lance Zhu on 2015-09-11.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import UIKit
import ReactiveCocoa
import ReactiveArray
import Dollar
import Cartography

public final class SocialBusiness_UtilityHeaderView : UIView {
    
    // MARK: - UI Controls
    private lazy var detailInfoButton: UIButton = {
        let button = UIButton()
        
        button.setTitle("详细信息", forState: .Normal)
        button.setTitleColor(UIColor.blackColor(), forState: .Normal)
        
        let press = Action<UIButton, Void, NoError> { [weak self] button in
            return SignalProducer { sink, disposable in
                if let this = self {
                    proxyNext(this._detailInfoSink, ())
                }
                sendCompleted(sink)
            }
        }
        
        button.addTarget(press.unsafeCocoaAction, action: CocoaAction.selector, forControlEvents: UIControlEvents.TouchUpInside)
        
        return button
    }()
    
    private lazy var startEventButton: UIButton = {
        let button = UIButton()
        
        button.setTitle("约起", forState: .Normal)
        button.setTitleColor(UIColor.blackColor(), forState: .Normal)
        
        let press = Action<UIButton, Void, NoError> { [weak self] button in
            return SignalProducer { sink, disposable in
                if let this = self {
                    proxyNext(this._startEventSink, ())
                }
                sendCompleted(sink)
                
            }
        }
        
        button.addTarget(press.unsafeCocoaAction, action: CocoaAction.selector, forControlEvents: UIControlEvents.TouchUpInside)
        
        return button
    }()
    
    // MARK: - Proxies
    private let (_detailInfoProxy, _detailInfoSink) = SimpleProxy.proxy()
    public var detailInfoProxy: SimpleProxy {
        return _detailInfoProxy
    }
    
    private let (_startEventProxy, _startEventSink) = SimpleProxy.proxy()
    public var startEventProxy: SimpleProxy {
        return _startEventProxy
    }
    
    // MARK: - Properties
    
    // MARK: - Initializers
    public init() {
        super.init(frame: CGRectMake(0, 0, 0, 0))
        
        setup()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    public required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setups
    
    private func setup() {
        backgroundColor = UIColor.whiteColor()
        opaque = true
        
        addSubview(detailInfoButton)
        addSubview(startEventButton)
        
        constrain(detailInfoButton) { view in
            view.top == view.superview!.top
            view.bottom == view.superview!.bottom
            view.leading == view.superview!.leadingMargin + 50
        }
        
        constrain(startEventButton) { view in
            view.top == view.superview!.top
            view.bottom == view.superview!.bottom
            view.trailing == view.superview!.trailingMargin - 50
        }
    }
}