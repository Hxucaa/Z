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

@IBDesignable
public final class LandingPageView : UIView {
    
    // MARK: - UI Controls
    @IBOutlet private weak var skipButton: UIButton?
    @IBOutlet private weak var loginButton: UIButton!
    @IBOutlet private weak var signUpButton: UIButton!
    @IBOutlet private weak var dividerLabel: UILabel?
    
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
    private let viewmodel = MutableProperty<LandingPageViewModel?>(nil)
    private let compositeDisposable = CompositeDisposable()
    
    // MARK: Setups
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        
        compositeDisposable += viewmodel.producer
            |> ignoreNil
            |> start(next: { [weak self] viewmodel in
                if viewmodel.rePrompt {
                    let rePromptButtonsView = UINib(nibName: RePromptButtonsViewNibName, bundle: nil).instantiateWithOwner(self, options: nil).first as! UIView
                    self?.addSubview(rePromptButtonsView)
                    self?.addConstraintsToButtonsView(rePromptButtonsView)
                }
                else {
                    let startUpButtonsView = UINib(nibName: StartUpButtonsViewNibName, bundle: nil).instantiateWithOwner(self, options: nil).first as! UIView
                    self?.addSubview(startUpButtonsView)
                    self?.addConstraintsToButtonsView(startUpButtonsView)
                }
                
                self?.setupLoginButton()
                self?.setupSignUpButton()
                self?.setupSkipButton()
                self?.setupDividerLabel()
                
            })
        
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
        
        signUpButton.addTarget(gotoSignup.unsafeCocoaAction, action: CocoaAction.selector, forControlEvents: .TouchUpInside)
    }
    
    private func setupSkipButton() {
        skipButton?.layer.masksToBounds = true
        skipButton?.layer.cornerRadius = 8
        
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
        
        skipButton?.addTarget(skip.unsafeCocoaAction, action: CocoaAction.selector, forControlEvents: .TouchUpInside)
    }
    
    private func setupDividerLabel() {
        dividerLabel?.layer.masksToBounds = false
        dividerLabel?.layer.shadowRadius = 3.0
        dividerLabel?.layer.shadowOpacity = 0.5
        dividerLabel?.layer.shadowOffset = CGSize.zeroSize
        
    }
    
    deinit {
        compositeDisposable.dispose()
        AccountLogVerbose("Landing Page View deinitializes.")
    }
    
    // MARK: - Bindings
    public func bindToViewModel(viewmodel: LandingPageViewModel) {
        self.viewmodel.put(viewmodel)
    }
    
    // MARK: - Others
    private func addConstraintsToButtonsView<V: UIView>(subview: V) {
        
        // turn off autoresizing mask off to allow custom autolayout constraints
        subview.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        // add constraints
        self.addConstraints(
            [
                // set height to 109
                NSLayoutConstraint(
                    item: subview,
                    attribute: NSLayoutAttribute.Height,
                    relatedBy: NSLayoutRelation.Equal,
                    toItem: nil,
                    attribute: NSLayoutAttribute.NotAnAttribute,
                    multiplier: 1.0,
                    constant: 109.0
                ),
                // set width to 247
                NSLayoutConstraint(
                    item: subview,
                    attribute: NSLayoutAttribute.Width,
                    relatedBy: NSLayoutRelation.Equal,
                    toItem: nil,
                    attribute: NSLayoutAttribute.NotAnAttribute,
                    multiplier: 1.0,
                    constant: 247.0
                ),
                // center at X = 0
                NSLayoutConstraint(
                    item: subview,
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
                    toItem: subview,
                    attribute: NSLayoutAttribute.Bottom,
                    multiplier: 1.0,
                    constant: 67.0
                )
            ]
        )
    }

}