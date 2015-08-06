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

public final class UsernameAndPasswordView : UIView {
    
    // MARK: - UI Controls
    @IBOutlet private weak var usernameField: UITextField!
    @IBOutlet private weak var passwordField: UITextField!
    
    // MARK: - Properties
    private var viewmodel: UsernameAndPasswordViewModel!
    private let compositeDisposable = CompositeDisposable()
    
    // MARK: - Proxies
    private let (_submitProxy, _submitSink) = SimpleProxy.proxy()
    public var submitProxy: SimpleProxy {
        return _submitProxy
    }
    
    // MARK: - Setups
    public override func awakeFromNib() {
        super.awakeFromNib()
        
        /**
        Setup constraints
        */
        
        /// The below two blocks of code achieve the same thing.

//        // width set to frame width
//        let width = NSLayoutConstraint(
//            item: self,
//            attribute: NSLayoutAttribute.Width,
//            relatedBy: NSLayoutRelation.Equal,
//            toItem: nil,
//            attribute: NSLayoutAttribute.NotAnAttribute,
//            multiplier: 1.0,
//            constant: frame.width
//        )
//        width.identifier = "width"
//        
//        // height set to frame height
//        let height = NSLayoutConstraint(
//            item: self,
//            attribute: NSLayoutAttribute.Height,
//            relatedBy: NSLayoutRelation.Equal,
//            toItem: nil,
//            attribute: NSLayoutAttribute.NotAnAttribute,
//            multiplier: 1.0,
//            constant: frame.height
//        )
//        height.identifier = "height"
//        
//        addConstraints(
//            [
//                width,
//                height
//            ]
//        )
        
        layout(self) { view in
            view.width == self.frame.width
            view.height == self.frame.height
        }
        
        usernameField.delegate = self
        passwordField.delegate = self
        
        
        usernameField.becomeFirstResponder()
    }
    
    // MARK: Bindings
    public func bindToViewModel(viewmodel: UsernameAndPasswordViewModel) {
        self.viewmodel = viewmodel
        
        // bind signals
        viewmodel.username <~ usernameField.rac_text
        viewmodel.password <~ passwordField.rac_text
        
        // TODO: implement different validation for different input fields.
        //        confirmButton.rac_enabled <~ viewmodel.allInputsValid
    }
    
    deinit {
        compositeDisposable.dispose()
        AccountLogVerbose("UsernameAndPasswordView deinitializes.")
    }
    
    // MARK: Others
}

extension UsernameAndPasswordView : UITextFieldDelegate {
    /**
    The text field calls this method whenever the user taps the return button. You can use this method to implement any custom behavior when the button is tapped.
    
    :param: textField The text field whose return button was pressed.
    
    :returns: YES if the text field should implement its default behavior for the return button; otherwise, NO.
    */
    public func textFieldShouldReturn(textField: UITextField) -> Bool {
        if usernameField == textField {
            passwordField.becomeFirstResponder()
        }
        else if passwordField == textField {
            passwordField.resignFirstResponder()
            compositeDisposable += viewmodel.allInputsValid.producer
                |> filter { $0 }
                |> start(next: { [weak self] _ in
                    if let this = self {
                        sendNext(this._submitSink, ())
                    }
                })
        }
        return false
    }
}