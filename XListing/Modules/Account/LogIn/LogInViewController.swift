//
//  LogInViewController.swift
//  XListing
//
//  Created by Lance Zhu on 2015-06-09.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import UIKit
import ReactKit

public final class LogInViewController: UIViewController {
    
    private var viewmodel: LogInViewModel!
    
    public func bindToViewModel(viewmodel: LogInViewModel) {
        self.viewmodel = viewmodel
    }
}