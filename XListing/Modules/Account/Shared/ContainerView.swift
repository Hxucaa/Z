//
//  ContainerView.swift
//  XListing
//
//  Created by Lance Zhu on 2015-08-14.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import UIKit
import ReactiveCocoa
import Cartography
import Spring

public final class ContainerView : UIView {
    
    // MARK: - UI Controls
    
    // MARK: Top Stack
    @IBOutlet private weak var _topStack: UIView!
    public var topStack: UIView {
        return _topStack
    }
    @IBOutlet private weak var _backButton: UIButton!
    public var backButton: UIButton {
        return _backButton
    }
    @IBOutlet private weak var _primaryLabel: UILabel!
    public var primaryLabel: UILabel {
        return _primaryLabel
    }
    @IBOutlet private weak var _secondaryLabel: UILabel!
    public var secondaryLabel: UILabel {
        return _secondaryLabel
    }
    
    // MARK: Mid Stack
    @IBOutlet private weak var _midStack: UIView!
    public var midStack: UIView {
        return _midStack
    }
    
    // MARK: Bottom Stack
    @IBOutlet private weak var _bottomStack: UIView!
    public var bottomStack: UIView {
        return _bottomStack
    }
    // MARK: - Proxies
    
    /// Go back to previous page.
    private let (_goBackProxy, _goBackSink) = SimpleProxy.proxy()
    public var goBackProxy: SimpleProxy {
        return _goBackProxy
    }
    
    /// Sign Up view is finished.
    private let (_finishSignUpProxy, _finishSignUpSink) = SimpleProxy.proxy()
    public var finishSignUpProxy: SimpleProxy {
        return _finishSignUpProxy
    }
    
    // MARK: - Setups
    public override func awakeFromNib() {
        super.awakeFromNib()
        
        setupBackButton()
        
    }
    
    private func setupBackButton () {
        let goBackAction = Action<UIButton, Void, NoError> { [weak self] button in
            return SignalProducer { [weak self] sink, disposable in
                self?.endEditing(true)
                
                sendCompleted(sink)
                
                if let this = self {
                    sendNext(this._goBackSink, ())
                }
            }
        }
        
        backButton.addTarget(goBackAction.unsafeCocoaAction, action: CocoaAction.selector, forControlEvents: UIControlEvents.TouchUpInside)
    }
}