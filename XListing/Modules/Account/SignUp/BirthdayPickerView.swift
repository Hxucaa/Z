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

public final class BirthdayPickerView : UIView {
    
    // MARK: - UI Controls
    @IBOutlet private weak var cakeIcon: CakeIcon!
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
    private let (_continueProxy, _continueSink) = SimpleProxy.proxy()
    public var continueProxy: SimpleProxy {
        return _continueProxy
    }
    
    // MARK: - Setups
    public override func awakeFromNib() {
        super.awakeFromNib()
        
        _continueButton.setTitle("继 续", forState: .Normal)
        
        let continueAction = Action<UIButton, Void, NoError> { [weak self] button in
            return SignalProducer { sink, disposable in
                if let this = self {
                    proxyNext(this._continueSink, ())
                    sendCompleted(sink)
                }
                }
                |> logLifeCycle(LogContext.Account, "continueButton Continue Action")
        }
        
        continueButton.addTarget(continueAction.unsafeCocoaAction, action: CocoaAction.selector, forControlEvents: .TouchUpInside)
        
        /**
        Setup constraints
        */
        let group = layout(self) { view in
            view.width == self.frame.width
            view.height == self.frame.height
        }
        
        let pickBirthday = Action<NSDate, Void, NoError> { [weak self] date in
            return SignalProducer { sink, disposable in
                self?.birthdayTextField.text = date.description
                self?._viewmodel.birthday.put(date)
                sendCompleted(sink)
            }
        }
        
        compositeDisposable += viewmodel.producer
            |> takeUntilRemoveFromSuperview(self)
            |> logLifeCycle(LogContext.Account, "viewmodel.producer")
            |> ignoreNil
            |> start(next: { [weak self] viewmodel in
                
                let picker = ActionSheetDatePicker(
                    title: "生日",
                    datePickerMode: UIDatePickerMode.Date,
                    selectedDate: NSDate(),
                    minimumDate: viewmodel.年龄下限.value,
                    maximumDate: viewmodel.年龄上限.value,
                    target: pickBirthday.unsafeCocoaAction,
                    action: CocoaAction.selector,
                    origin: self
                )
                picker.hideCancel = true
                picker.showActionSheetPicker()
            })
        
    }
    
    
    deinit {
        compositeDisposable.dispose()
        AccountLogVerbose("NicknameView deinitializes.")
    }
    
    // MARK: - Bindings
    
    // MARK: - Others
}