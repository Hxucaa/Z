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

/**
This is a container view which is shared between the log in and sign up views.

This view contains three UIViews that are stacked horizontally. The top and middle stacks have a fixed height and are
clipped to leading, top and trailing of the container view. The bottom part can be resized to fit the height of 
different devices. The middle stack will have different text fields or input methods based on the need of the calling
view controllers.

*/

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
    private let (_goBackProxy, _goBackObserver) = SimpleProxy.proxy()
    public var goBackProxy: SimpleProxy {
        return _goBackProxy
    }
    
    // MARK: - Setups
    public override func awakeFromNib() {
        super.awakeFromNib()
        
        setupBackButton()
        
    }
    
    private func setupBackButton () {
        let goBackAction = Action<UIButton, Void, NoError> { [weak self] button in
            return SignalProducer { [weak self] observer, disposable in
                self?.endEditing(true)
                
                observer.sendCompleted()
                
                if let this = self {
                    sendNext(this._goBackObserver, ())
                }
            }
        }
        
        backButton.addTarget(goBackAction.unsafeCocoaAction, action: CocoaAction.selector, forControlEvents: UIControlEvents.TouchUpInside)
    }
}