//
//  GenderPickerView.swift
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

public final class GenderPickerView : SpringView {
    
    // MARK: - UI Controls
    @IBOutlet private weak var boyButton: BoyButton!
    @IBOutlet private weak var girlButton: GirlButton!
    private let _continueButton = RoundedButton()
    public var continueButton: RoundedButton {
        return _continueButton
    }
    
    // MARK: - Properties
    private var viewmodel: GenderPickerViewModel!
    private let compositeDisposable = CompositeDisposable()
    
    // MARK: - Proxies
    private let (_continueProxy, _continueSink) = SimpleProxy.proxy()
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
                self?._continueSink.proxyNext(())
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
        *  Setup boy button
        */
        let boy = Action<UIButton, Void, NoError> { [weak self] button in
            return SignalProducer { observer, disposable in
                self?.viewmodel.gender.value = Gender.Male
                self?.girlButton.tintColor = UIColor.whiteColor()
                self?.girlButton.selected = false
                observer.sendCompleted()
            }
        }
        boyButton.addTarget(boy.unsafeCocoaAction, action: CocoaAction.selector, forControlEvents: .TouchUpInside)
        
        
        /**
        *  Setup girl button
        */
        let girl = Action<UIButton, Void, NoError> { [weak self] button in
            return SignalProducer { observer, disposable in
                self?.viewmodel.gender.value = Gender.Female
                self?.boyButton.tintColor = UIColor.whiteColor()
                self?.boyButton.selected = false
                observer.sendCompleted()
            }
        }
        girlButton.addTarget(girl.unsafeCocoaAction, action: CocoaAction.selector, forControlEvents: .TouchUpInside)
        
    }
    
    
    deinit {
        compositeDisposable.dispose()
        AccountLogVerbose("GenderPickerView deinitializes.")
    }
    
    // MARK: - Bindings
    public func bindToViewModel(viewmodel: GenderPickerViewModel) {
        self.viewmodel = viewmodel
        
        _continueButton.rac_enabled <~ viewmodel.isGenderValid
    }
    
    // MARK: - Others
}