//
//  UsernameAndPasswordView.swift
//  XListing
//
//  Created by Lance Zhu on 2015-08-05.
//  Copyright (c) 2016 Lance Zhu. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import Cartography

final class UsernameAndPasswordView : UIView {
    
    // MARK: - UI Controls
    @IBOutlet private weak var usernameField: UITextField!
    @IBOutlet private weak var passwordField: UITextField!
    private let _signUpButton = RoundedButton()
    var signUpButton: RoundedButton {
        return _signUpButton
    }
    
    var usernameFieldText: ControlProperty<String> {
        return usernameField.rx_text
    }
    
    var passwordFieldText: ControlProperty<String> {
        return passwordField.rx_text
    }
    
    var submitTap: ControlEvent<Void> {
        return _signUpButton.rx_tap
    }
    
    // MARK: - Setups
    override func awakeFromNib() {
        super.awakeFromNib()
        
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
    
    // MARK: Bindings
    func bindToData(signUpEnabled: Observable<Bool>) {
        signUpEnabled
            .bindTo(_signUpButton.rx_enabled)
    }
    
    // MARK: Others
    func setButtonTitle(text: String) {
        _signUpButton.setTitle(text, forState: .Normal)
    }
}

extension UsernameAndPasswordView : UITextFieldDelegate {
    /**
    The text field calls this method whenever the user taps the return button. You can use this method to implement any custom behavior when the button is tapped.
    
    - parameter textField: The text field whose return button was pressed.
    
    - returns: YES if the text field should implement its default behavior for the return button; otherwise, NO.
    */
    func textFieldShouldReturn(textField: UITextField) -> Bool {
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