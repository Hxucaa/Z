//
//  BirthdayPickerView.swift
//  XListing
//
//  Created by Lance Zhu on 2015-08-06.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import UIKit
import ReactiveCocoa
import Cartography
import ActionSheetPicker_3_0
import Spring

public final class BirthdayPickerView : SpringView {
    
    // MARK: - UI Controls
    @IBOutlet private weak var birthdayTextField: UITextField!
    private let _continueButton = RoundedButton()
    public var continueButton: RoundedButton {
        return _continueButton
    }
    
    // MARK: - Properties
    private var viewmodel: BirthdayPickerViewModel!
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
        *  Setup continueButton
        */
        _continueButton.setTitle("继 续", forState: .Normal)
        
        let continueAction = Action<UIButton, Void, NoError> { [weak self] button in
            return SignalProducer { observer, disposable in
                self?._continueObserver.proxyNext(())
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
    }
    
    
    deinit {
        compositeDisposable.dispose()
        AccountLogVerbose("NicknameView deinitializes.")
    }
    
    // MARK: - Bindings
    public func bindToViewModel(viewmodel: BirthdayPickerViewModel) {
        self.viewmodel = viewmodel
        
        _continueButton.rac_enabled <~ viewmodel.isBirthdayValid
        birthdayTextField.rac_text <~ viewmodel.birthdayText
        
        
        /**
         *  Setup birthday picker
         */
        let pickBirthday = Action<NSDate, Void, NoError> { [weak self] date in
            return SignalProducer { observer, disposable in
                self?.birthdayTextField.text = date.description
                self?.viewmodel.birthday.value = date
                observer.sendCompleted()
            }
        }
        
        let picker = ActionSheetDatePicker(
            title: "生日",
            datePickerMode: UIDatePickerMode.Date,
            selectedDate: viewmodel.pickerUpperLimit,
            minimumDate: viewmodel.pickerLowerLimit,
            maximumDate: viewmodel.pickerUpperLimit,
            target: pickBirthday.unsafeCocoaAction,
            action: CocoaAction.selector,
            origin: self
        )
        picker.hideCancel = true
        picker.showActionSheetPicker()
    }
    
    // MARK: - Others
}