//
//  UsernameAndPasswordView.swift
//  XListing
//
//  Created by Lance Zhu on 2015-08-05.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import UIKit
import ReactiveCocoa
import Cartography
import Spring

public final class UsernameAndPasswordView : SpringView {
    
    // MARK: - UI Controls
    @IBOutlet private weak var usernameField: UITextField!
    @IBOutlet private weak var passwordField: UITextField!
    private let _signUpButton = RoundedButton()
    public var signUpButton: RoundedButton {
        return _signUpButton
    }
    
    // MARK: - Properties
    private var viewmodel: UsernameAndPasswordViewModel!
    private let compositeDisposable = CompositeDisposable()
    
    // MARK: - Proxies
    private let (_submitProxy, _submitObserver) = SimpleProxy.proxy()
    public var submitProxy: SimpleProxy {
        return _submitProxy
    }
    
    // MARK: - Setups
    public override func awakeFromNib() {
        super.awakeFromNib()
        
        let submitAction = Action<UIButton, Void, NSError> { [weak self] button in
            return SignalProducer { observer, disposable in
                
                self?._submitObserver.proxyNext(())
                
                // retract keyboard
                self?.endEditing(true)
                
                observer.sendCompleted()
            }

        }
        
        
        // Link UIControl event to actions
        _signUpButton.addTarget(submitAction.unsafeCocoaAction, action: CocoaAction.selector, forControlEvents: UIControlEvents.TouchUpInside)
        
        /**
        Setup constraints
        */
        
        constrain(self) { view in
            view.width == self.frame.width
            view.height == self.frame.height
        }
        
        usernameField.delegate = self
        passwordField.delegate = self
        usernameField.becomeFirstResponder()
    }
    
    deinit {
        compositeDisposable.dispose()
    }
    
    // MARK: Bindings
    public func bindToViewModel(viewmodel: UsernameAndPasswordViewModel) {
        self.viewmodel = viewmodel
        
        // bind signals
        viewmodel.username <~ usernameField.rac_text
        viewmodel.password <~ passwordField.rac_text
        
        // TODO: implement different validation for different input fields.
        _signUpButton.rac_enabled <~ viewmodel.allInputsValid
    }
    
    // MARK: Others
    public func setButtonTitle(text: String) {
        _signUpButton.setTitle(text, forState: .Normal)
    }
}

extension UsernameAndPasswordView : UITextFieldDelegate {
    /**
    The text field calls this method whenever the user taps the return button. You can use this method to implement any custom behavior when the button is tapped.
    
    - parameter textField: The text field whose return button was pressed.
    
    - returns: YES if the text field should implement its default behavior for the return button; otherwise, NO.
    */
    public func textFieldShouldReturn(textField: UITextField) -> Bool {
        if usernameField == textField {
            passwordField.becomeFirstResponder()
        }
        else if passwordField == textField {
            passwordField.resignFirstResponder()
            
            _signUpButton.sendActionsForControlEvents(.TouchUpInside)
        }
        return false
    }
}