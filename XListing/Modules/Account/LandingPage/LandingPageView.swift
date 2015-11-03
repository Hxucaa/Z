//
//  LandingPageView.swift
//  XListing
//
//  Created by Lance Zhu on 2015-07-12.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

/**
There are two version of LandingPageView depending on where the account module is initiazted from.
Each of which has a slightly different interface. When it is the first time the account module is 
loaded, the `StartUpButtonsView` is loaded. However, when other modules present the account module, 
the `RePromptButtonsView` is loaded.
*/

import Foundation
import UIKit
import ReactiveCocoa

private let StartUpButtonsViewNibName = "StartUpButtonsView"
private let RePromptButtonsViewNibName = "RePromptButtonsView"
private let BackButtonNibName = "BackButton"

public final class LandingPageView : UIView {
    
    // MARK: - UI Controls
    @IBOutlet private weak var skipButton: UIButton?
    @IBOutlet private weak var loginButton: UIButton!
    @IBOutlet private weak var signUpButton: UIButton!
    @IBOutlet private weak var dividerLabel: UILabel?
    @IBOutlet private weak var backButton: UIButton?
    
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
    
    
    // MARK: - Properties
    private let viewmodel = MutableProperty<ILandingPageViewModel?>(nil)
    private let compositeDisposable = CompositeDisposable()
    
    // MARK: - Actions
    /// Skip this view
    private lazy var skipAction: Action<UIButton, Void, NoError> = Action<UIButton, Void, NoError> { [weak self] button in
        return SignalProducer { sink, disposable in
            if let this = self {
                // send event to skip proxy
                sendNext(this._skipSink, ())
            }
            
            // completes this action
            sendCompleted(sink)
        }
    }
    
    // MARK: - Setups
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        
        compositeDisposable += viewmodel.producer
            .ignoreNil
            .start(next: { [weak self] viewmodel in
                // conditionally load subviews
                if viewmodel.rePrompt {
                    self?.setupButtonsView(RePromptButtonsViewNibName)
                    self?.setupBackButton()
                }
                else {
                    self?.setupButtonsView(StartUpButtonsViewNibName)
                }
                
                // setup other UI elements
                self?.setupLoginButton()
                self?.setupSignUpButton()
                self?.setupSkipButton()
                self?.setupDividerLabel()
                
            })
        
    }
    
    private func setupButtonsView(nibName: String) {
        
        // load view
        let view = UINib(nibName: nibName, bundle: nil).instantiateWithOwner(self, options: nil).first as! UIView
        // add to subview
        addSubview(view)
        
        // turn off autoresizing mask off to allow custom autolayout constraints
        view.translatesAutoresizingMaskIntoConstraints = false
        
        // add constraints
        addConstraints(
            [
                // set height to 109
                NSLayoutConstraint(
                    item: view,
                    attribute: NSLayoutAttribute.Height,
                    relatedBy: NSLayoutRelation.Equal,
                    toItem: nil,
                    attribute: NSLayoutAttribute.NotAnAttribute,
                    multiplier: 1.0,
                    constant: 109.0
                ),
                // set width to 247
                NSLayoutConstraint(
                    item: view,
                    attribute: NSLayoutAttribute.Width,
                    relatedBy: NSLayoutRelation.Equal,
                    toItem: nil,
                    attribute: NSLayoutAttribute.NotAnAttribute,
                    multiplier: 1.0,
                    constant: 247.0
                ),
                // center at X = 0
                NSLayoutConstraint(
                    item: view,
                    attribute: NSLayoutAttribute.CenterX,
                    relatedBy: NSLayoutRelation.Equal,
                    toItem: self,
                    attribute: NSLayoutAttribute.CenterX,
                    multiplier: 1.0,
                    constant: 0.0
                ),
                // botom space to view is 67
                NSLayoutConstraint(
                    item: self,
                    attribute: NSLayoutAttribute.Bottom,
                    relatedBy: NSLayoutRelation.Equal,
                    toItem: view,
                    attribute: NSLayoutAttribute.Bottom,
                    multiplier: 1.0,
                    constant: 67.0
                )
            ]
        )
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
        signUpButton.layer.masksToBounds = true
        signUpButton.layer.cornerRadius = 8
        let gotoSignup = Action<UIButton, Void, NoError> { [weak self] button in
            return SignalProducer { sink, disposable in
                if let this = self {
                    sendNext(this._signUpSink, ())
                }
                
                sendCompleted(sink)
            }
        }
        
        signUpButton.addTarget(gotoSignup.unsafeCocoaAction, action: CocoaAction.selector, forControlEvents: .TouchUpInside)
    }
    
    private func setupSkipButton() {
        skipButton?.layer.masksToBounds = true
        skipButton?.layer.cornerRadius = 8
        
        skipButton?.addTarget(skipAction.unsafeCocoaAction, action: CocoaAction.selector, forControlEvents: .TouchUpInside)
    }
    
    private func setupDividerLabel() {
        dividerLabel?.layer.masksToBounds = false
        dividerLabel?.layer.shadowRadius = 3.0
        dividerLabel?.layer.shadowOpacity = 0.5
        dividerLabel?.layer.shadowOffset = CGSize.zero
        
    }
    
    private func setupBackButton() {
        
        // load back button
        let backButtonView = UINib(nibName: BackButtonNibName, bundle: nil).instantiateWithOwner(self, options: nil).first as! UIView
        // add back button to subview
        addSubview(backButtonView)
        
        // turn off autoresizing mask off to allow custom autolayout constraints
        backButtonView.translatesAutoresizingMaskIntoConstraints = false
        
        // leading margin 8.0
        let backButtonLeading = NSLayoutConstraint(
            item: backButtonView,
            attribute: NSLayoutAttribute.Leading,
            relatedBy: NSLayoutRelation.Equal,
            toItem: self,
            attribute: NSLayoutAttribute.LeadingMargin,
            multiplier: 1.0,
            constant: 0
        )
        backButtonLeading.identifier = "backButton leading constraint"
        
        // top margin 8.0
        let backButtonTop = NSLayoutConstraint(
            item: backButtonView,
            attribute: NSLayoutAttribute.Top,
            relatedBy: NSLayoutRelation.Equal,
            toItem: self,
            attribute: NSLayoutAttribute.TopMargin,
            multiplier: 1.0,
            constant: 9.0
        )
        backButtonTop.identifier = "backButton top constraint"
        
        // add constraints
        addConstraints(
            [
                backButtonLeading,
                backButtonTop
            ]
        )
        
        backButton?.addTarget(skipAction.unsafeCocoaAction, action: CocoaAction.selector, forControlEvents: .TouchUpInside)
    }
    
    deinit {
        compositeDisposable.dispose()
        AccountLogVerbose("Landing Page View deinitializes.")
    }
    
    // MARK: - Bindings
    public func bindToViewModel(viewmodel: ILandingPageViewModel) {
        self.viewmodel.put(viewmodel)
    }
    
    // MARK: - Others
}