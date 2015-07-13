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

public final class LandingPageView : UIView {
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var skipButton: UIButton!
    
    // MARK: Actions
    private var dismissViewButtonAction: CocoaAction!
    
    public weak var delegate: LandingViewDelegate!
    
    private var viewmodel: LandingPageViewModel!
    private var dismissCallback: CompletionHandler?
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        setupLoginButton()
        setupSignUpButton()
        setupSkipButton()
    }
    
    public func bindToViewModel(viewmodel: LandingPageViewModel, dismissCallback: CompletionHandler? = nil) {
        self.viewmodel = viewmodel
        self.dismissCallback = dismissCallback
    }
    
//    private func setUpLabels () {
//        self.backgroundLabel.layer.masksToBounds = true;
//        self.backgroundLabel.layer.cornerRadius = 8;
//        self.dividerLabel.layer.masksToBounds = false
//        self.dividerLabel.layer.shadowRadius = 3.0
//        self.dividerLabel.layer.shadowOpacity = 0.5
//        self.dividerLabel.layer.shadowOffset = CGSizeZero;
//    }
    
    private func setupLoginButton() {
        let gotoLogin = Action<UIButton, Void, NoError> { [unowned self] button in
            return SignalProducer { [unowned self] sink, disposable in
                self.delegate.switchToLoginView()
                sendCompleted(sink)
            }
        }
        
        loginButton.addTarget(gotoLogin.unsafeCocoaAction, action: CocoaAction.selector, forControlEvents: .TouchUpInside)
    }
    
    private func setupSignUpButton() {
        let gotoSignup = Action<UIButton, Void, NoError> { [unowned self] button in
            return SignalProducer { [unowned self] sink, disposable in
                self.delegate.switchToSignUpView()
                sendCompleted(sink)
            }
        }
        
        signupButton.addTarget(gotoSignup.unsafeCocoaAction, action: CocoaAction.selector, forControlEvents: .TouchUpInside)
    }
    
    private func setupSkipButton() {
        // Action to an UI event
        let skip = Action<UIButton, Void, NoError> { [unowned self] button in
            return SignalProducer { [unowned self] sink, disposable in
                self.delegate.skip()
                sendCompleted(sink)
            }
        }
        
        skipButton.addTarget(skip.unsafeCocoaAction, action: CocoaAction.selector, forControlEvents: .TouchUpInside)
    }
}