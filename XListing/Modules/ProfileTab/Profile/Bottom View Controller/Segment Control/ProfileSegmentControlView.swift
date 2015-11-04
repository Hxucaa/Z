//
//  ProfileSegmentControlView.swift
//  XListing
//
//  Created by Lance Zhu on 2015-10-07.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import UIKit
import TZStackView
import Cartography
import TTTAttributedLabel
import ReactiveCocoa
import XAssets

public final class ProfileSegmentControlView : ButtonPageControl {
    
    // MARK: - UI Controls
    
    private lazy var participationListbutton: UIButton = {
        let button = UIButton()
        button.opaque = true
        
        AssetFactory.getImage(Asset.TreatIcon(size: CGSizeMake(35, 35), backgroundColor: .whiteColor(), opaque: true, imageContextScale: nil, pressed: false, shadow: false))
            .startWithNext { [weak button] image in
                button?.setImage(image, forState: .Normal)
            }
        
        let action = Action<UIButton, Void, NoError> { [weak self] button in
            return SignalProducer { observer, disposable in
                if let this = self {
                    this._participationListObserver.proxyNext(())
                }
                observer.sendCompleted()
            }
        }
        
        button.addTarget(action.unsafeCocoaAction, action: CocoaAction.selector, forControlEvents: .TouchUpInside)
        
        
        return button
    }()
    
    private lazy var photosManagerButton: UIButton = {
        let button = UIButton()
        button.opaque = true
        
        AssetFactory.getImage(Asset.TreatIcon(size: CGSizeMake(35, 35), backgroundColor: .whiteColor(), opaque: true, imageContextScale: nil, pressed: false, shadow: false))
            .startWithNext({ [weak button] image in
                button?.setImage(image, forState: .Normal)
            })
        
        let action = Action<UIButton, Void, NoError> { [weak self] button in
            return SignalProducer { observer, disposable in
                if let this = self {
                    this._photosManagerObserver.proxyNext(())
                }
                observer.sendCompleted()
            }
        }
        
        button.addTarget(action.unsafeCocoaAction, action: CocoaAction.selector, forControlEvents: .TouchUpInside)
        
        
        return button
    }()
    
    // MARK: - Proxies
    
    private let (_participationListProxy, _participationListObserver) = SimpleProxy.proxy()
    public var participationListProxy: SimpleProxy {
        return _participationListProxy
    }
    
    private let (_photosManagerProxy, _photosManagerObserver) = SimpleProxy.proxy()
    public var photosManagerProxy: SimpleProxy {
        return _photosManagerProxy
    }
    
    // MARK: - Properties
    
    // MARK: - Initializers
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setup()
    }
    
    // MARK: - Setups
    
    private func setup() {
        buttonContainer.addArrangedSubview(participationListbutton)
        buttonContainer.addArrangedSubview(photosManagerButton)
    }
    
    // MARK: - Bindings
}