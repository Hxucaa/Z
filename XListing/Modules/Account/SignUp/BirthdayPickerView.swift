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

public final class BirthdayPickerView : UIView {
    
    // MARK: - UI Controls
    
    // MARK: - Properties
    private var viewmodel: BirthdayPickerViewModel!
    private let compositeDisposable = CompositeDisposable()
    
    // MARK: - Proxies
    
    // MARK: - Setups
    public override func awakeFromNib() {
        super.awakeFromNib()
        
        /**
        Setup constraints
        */
        let group = layout(self) { view in
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
        
        // bind signals
        
        // TODO: implement different validation for different input fields.
        //        confirmButton.rac_enabled <~ viewmodel.allInputsValid
    }
    
    // MARK: - Others
}