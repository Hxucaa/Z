//
//  SignUpViewController.swift
//  XListing
//
//  Created by Lance Zhu on 2015-06-09.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import UIKit
import ReactKit

public final class SignUpViewController : UIViewController {
    private var viewmodel: SignUpViewModel!
    
    public func bindToViewModel(viewmodel: SignUpViewModel) {
        self.viewmodel = viewmodel
    }
}