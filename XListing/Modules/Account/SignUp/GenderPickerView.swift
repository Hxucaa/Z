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
import Cartography
import XAssets

public final class GenderPickerView : UIView {
    
    // MARK: - UI Controls
    @IBOutlet private weak var boyButton: BoyButton!
    @IBOutlet private weak var girlButton: GirlButton!
    private let _continueButton = RoundedButton()
    public var continueButton: RoundedButton {
        return _continueButton
    }
    
    // MARK: - Properties
    public let viewmodel = MutableProperty<GenderPickerViewModel?>(nil)
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
        
        let boy = Action<UIButton, Void, NoError> { [weak self] button in
            return SignalProducer { sink, disposable in
                self?.viewmodel.value?.gender.put(Gender.Male)
                sendCompleted(sink)
            }
        }
        boyButton.addTarget(boy.unsafeCocoaAction, action: CocoaAction.selector, forControlEvents: .TouchUpInside)
        
        
        let girl = Action<UIButton, Void, NoError> { [weak self] button in
            return SignalProducer { sink, disposable in
                self?.viewmodel.value?.gender.put(Gender.Female)
                sendCompleted(sink)
            }
        }
        girlButton.addTarget(girl.unsafeCocoaAction, action: CocoaAction.selector, forControlEvents: .TouchUpInside)
        
        compositeDisposable += viewmodel.producer
            |> takeUntilRemoveFromSuperview(self)
            |> logLifeCycle(LogContext.Account, "viewmodel.producer")
            |> ignoreNil
            |> start(next: { [weak self] viewmodel in
                
            })
    }
    
    
    deinit {
        compositeDisposable.dispose()
        AccountLogVerbose("GenderPickerView deinitializes.")
    }
    
    // MARK: - Bindings
    
    // MARK: - Others
}