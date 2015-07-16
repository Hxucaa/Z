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
    @IBOutlet weak var dividerLabel: UILabel!
    
    // MARK: Actions
    private var dismissViewButtonAction: CocoaAction!
    
    public weak var delegate: LandingViewDelegate?
    
    private var viewmodel: LandingPageViewModel!
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        setupLoginButton()
        setupSignUpButton()
        setupSkipButton()
        setupDividerLabel()
    }
    
    public func bindToViewModel(viewmodel: LandingPageViewModel) {
        self.viewmodel = viewmodel
    }
    
    private func setupLoginButton() {
        let gotoLogin = Action<UIButton, Void, NoError> { [unowned self] button in
            return SignalProducer { [unowned self] sink, disposable in
                self.delegate?.switchToLoginView()
                sendCompleted(sink)
            }
        }
        
        loginButton.addTarget(gotoLogin.unsafeCocoaAction, action: CocoaAction.selector, forControlEvents: .TouchUpInside)
    }
    
    private func setupSignUpButton() {
        let gotoSignup = Action<UIButton, Void, NoError> { [unowned self] button in
            return SignalProducer { [unowned self] sink, disposable in
                self.delegate?.switchToSignUpView()
                sendCompleted(sink)
            }
        }
        
        signupButton.addTarget(gotoSignup.unsafeCocoaAction, action: CocoaAction.selector, forControlEvents: .TouchUpInside)
    }
    
    private func setupSkipButton() {
        skipButton.layer.masksToBounds = true
        skipButton.layer.cornerRadius = 8
        
        // Action to an UI event
        let skip = Action<UIButton, Void, NoError> { [unowned self] button in
            return SignalProducer { [unowned self] sink, disposable in
                self.delegate?.skip()
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
}