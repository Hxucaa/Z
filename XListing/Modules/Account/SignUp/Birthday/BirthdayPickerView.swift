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
    public let viewmodel = MutableProperty<BirthdayPickerViewModel?>(nil)
    private var _viewmodel: BirthdayPickerViewModel {
        return viewmodel.value!
    }
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
        
        /**
        *  Setup birthday picker
        */
        let pickBirthday = Action<NSDate, Void, NoError> { [weak self] date in
            return SignalProducer { observer, disposable in
                self?.birthdayTextField.text = date.description
                self?._viewmodel.birthday.value = date
                observer.sendCompleted()
            }
        }
        
        // show the birthday picker as soon as the view is displayed
        compositeDisposable += viewmodel.producer
            .takeUntilRemoveFromSuperview(self)
            .logLifeCycle(LogContext.Account, signalName: "viewmodel.producer")
            .ignoreNil()
            .startWithNext { [weak self] viewmodel in
                
                let picker = ActionSheetDatePicker(
                    title: "生日",
                    datePickerMode: UIDatePickerMode.Date,
                    selectedDate: viewmodel.pickerUpperLimit.value,
                    minimumDate: viewmodel.pickerLowerLimit.value,
                    maximumDate: viewmodel.pickerUpperLimit.value,
                    target: pickBirthday.unsafeCocoaAction,
                    action: CocoaAction.selector,
                    origin: self
                )
                picker.hideCancel = true
                picker.showActionSheetPicker()
                
                if let this = self {
                    this._continueButton.rac_enabled <~ viewmodel.isBirthdayValid
                    this.birthdayTextField.rac_text <~ viewmodel.birthdayText
                }
            }
    }
    
    
    deinit {
        compositeDisposable.dispose()
        AccountLogVerbose("NicknameView deinitializes.")
    }
    
    // MARK: - Bindings
    
    // MARK: - Others
}