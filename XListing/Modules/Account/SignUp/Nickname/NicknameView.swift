//
//  NicknameView.swift
//  XListing
//
//  Created by Lance Zhu on 2015-08-06.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import UIKit
import ReactiveCocoa
import Result
import Cartography
import Spring

public final class NicknameView : SpringView {
    
    // MARK: - UI Controls
    @IBOutlet private weak var nicknameField: UITextField!
    private let _continueButton = RoundedButton()
    public var continueButton: RoundedButton {
        return _continueButton
    }
    
    // MARK: - Properties
    private var viewmodel: NicknameViewModel!
    private let compositeDisposable = CompositeDisposable()
    
    // MARK: - Proxies
    private let (_continueProxy, _continueObserver) = SimpleProxy.proxy()
    public var continueProxy: SimpleProxy {
        return _continueProxy
    }
    
    // MARK: - Setups
    public override func awakeFromNib() {
        super.awakeFromNib()
        
        /**
        *  Setup continue button
        */
        _continueButton.setTitle("继 续", forState: .Normal)
        
        let continueAction = Action<UIButton, Void, NoError> { [weak self] button in
            return SignalProducer { observer, disposable in
                if let this = self {
                    this._continueObserver.proxyNext(())
                }
                observer.sendCompleted()
            }
            .logLifeCycle(LogContext.Account, signalName: "continueButton Continue Action")
        }
        
        continueButton.addTarget(continueAction.unsafeCocoaAction, action: CocoaAction.selector, forControlEvents: .TouchUpInside)
        
        /**
        Setup constraints
        */
        constrain(self) { view in
            view.width == self.frame.width
            view.height == self.frame.height
        }
        
        /**
        *  Setup nickname field
        */
        nicknameField.delegate = self
        nicknameField.becomeFirstResponder()
        
    }
    
    public override func removeFromSuperview() {
        super.removeFromSuperview()
        
        nicknameField.resignFirstResponder()
    }
    
    deinit {
        compositeDisposable.dispose()
        AccountLogVerbose("NicknameView deinitializes.")
    }
    
    // MARK: - Bindings
    public func bindToViewModel(viewmodel: NicknameViewModel) {
        self.viewmodel = viewmodel

        viewmodel.nickname <~ nicknameField.rac_text
        
        continueButton.rac_enabled <~ viewmodel.isNicknameValid
    }
    
    // MARK: - Others
}

extension NicknameView : UITextFieldDelegate {
    /**
    The text field calls this method whenever the user taps the return button. You can use this method to implement any custom behavior when the button is tapped.
    
    - parameter textField: The text field whose return button was pressed.
    
    - returns: YES if the text field should implement its default behavior for the return button; otherwise, NO.
    */
    public func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == nicknameField {
            // resign nickname field from first responder
            nicknameField.resignFirstResponder()
            // send touch event to continue button
            _continueButton.sendActionsForControlEvents(.TouchUpInside)
        }
        
        return false
    }
}