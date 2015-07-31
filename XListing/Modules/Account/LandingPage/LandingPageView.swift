//
//  LandingPageView.swift
//  XListing
//
//  Created by Lance Zhu on 2015-07-12.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import UIKit
import ReactiveCocoa

@IBDesignable
public final class LandingPageView : UIView {
    
    // MARK: - UI
    // MARK: Controls
    @IBOutlet private weak var loginButton: UIButton!
    @IBOutlet private weak var signupButton: UIButton!
    @IBOutlet private weak var skipButton: UIButton!
    @IBOutlet private weak var dividerLabel: UILabel!
    
    // MARK: - Proxies
    
    /// Skip Landing view.
    public var skipProxy: SimpleProxy {
        return _skipProxy
    }
    private let (_skipProxy, _skipSink) = SimpleProxy.proxy()
    
    /// Go to Log In view.
    public var loginProxy: SimpleProxy {
        return _loginProxy
    }
    private let (_loginProxy, _loginSink) = SimpleProxy.proxy()
    
    /// Go to Sign Up view.
    public var signUpProxy: SimpleProxy {
        return _signUpProxy
    }
    private let (_signUpProxy, _signUpSink) = SimpleProxy.proxy()
    
    
    // MARK: Properties
    private var viewmodel: LandingPageViewModel!
    
    // MARK: Setups
    public override func awakeFromNib() {
        super.awakeFromNib()
        
        setupLoginButton()
        setupSignUpButton()
        setupSkipButton()
        setupDividerLabel()
    }
    
    private func setupLoginButton() {
        let gotoLogin = Action<UIButton, Void, NoError> { [weak self] button in
            return SignalProducer { sink, disposable in
                if let this = self {
                    sendNext(this._loginSink, ())
                }
                
                sendCompleted(sink)
            }
        }
        
        loginButton.addTarget(gotoLogin.unsafeCocoaAction, action: CocoaAction.selector, forControlEvents: .TouchUpInside)
    }
    
    private func setupSignUpButton() {
        let gotoSignup = Action<UIButton, Void, NoError> { [weak self] button in
            return SignalProducer { sink, disposable in
                if let this = self {
                    sendNext(this._signUpSink, ())
                }
                
                sendCompleted(sink)
            }
        }
        
        signupButton.addTarget(gotoSignup.unsafeCocoaAction, action: CocoaAction.selector, forControlEvents: .TouchUpInside)
    }
    
    private func setupSkipButton() {
        skipButton.layer.masksToBounds = true
        skipButton.layer.cornerRadius = 8
        
        // Action to an UI event
        let skip = Action<UIButton, Void, NoError> { [weak self] button in
            return SignalProducer { sink, disposable in
                if let this = self {
                    // send event to skip proxy
                    sendNext(this._skipSink, ())
                }
                
                // completes this action
                sendCompleted(sink)
            }
        }
        
        skipButton.addTarget(skip.unsafeCocoaAction, action: CocoaAction.selector, forControlEvents: .TouchUpInside)
    }
    
    private func setupDividerLabel() {
        dividerLabel.layer.masksToBounds = false
        dividerLabel.layer.shadowRadius = 3.0
        dividerLabel.layer.shadowOpacity = 0.5
        dividerLabel.layer.shadowOffset = CGSize.zeroSize
        
    }
    
    deinit {
        AccountLogVerbose("Landing Page View deinitializes.")
    }
    
    // MARK: Bindings
    public func bindToViewModel(viewmodel: LandingPageViewModel) {
        self.viewmodel = viewmodel
    }
}