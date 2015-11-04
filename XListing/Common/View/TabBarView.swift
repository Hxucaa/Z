//
//  TabBarView.swift
//  XListing
//
//  Created by Lance Zhu on 2015-10-10.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import UIKit
import Cartography
import ReactiveCocoa

public class TabBarView: UIView {
    
    // MARK: - UI Controls
    public let label = UILabel()
    
    // MARK: - Properties

    
    // MARK: - Proxies
    private let (_tapGestureProxy, _tapGestureSink) = SimpleProxy.proxy()
    public var tapGestureProxy: SimpleProxy {
        return _tapGestureProxy
    }
    
    // MARK: - Initializers
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        userInteractionEnabled = true
        opaque = true
        backgroundColor = UIColor.whiteColor()
        self.addSubview(label)
        
        constrain(label) { label in
            label.center == label.superview!.center
        }
        
        let gesture = UITapGestureRecognizer()
        addGestureRecognizer(gesture)
        
        gesture.rac_gestureSignal().toSignalProducer()
            |> start(next: { [weak self] _ in
                if let this = self {
                    proxyNext(this._tapGestureSink, ())
                }
            })
        
    }
    
    public required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setups
    
    public override func intrinsicContentSize() -> CGSize {
        return self.bounds.size
    }
    
    // MARK: - Bindings
    
    // MARK: - Others
}
