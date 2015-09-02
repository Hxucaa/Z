//
//  SocialBusinessViewController.swift
//  XListing
//
//  Created by Lance Zhu on 2015-08-30.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import UIKit
import ReactiveCocoa
import ReactiveArray
import Dollar

public final class SocialBusinessViewController : UIViewController {
    
    // MARK: - Properties
    private var viewmodel: ISocialBusinessViewModel!
    
    // MARK: - Bindings
    
    public func bindToViewModel(viewmodel: ISocialBusinessViewModel) {
        self.viewmodel = viewmodel
        
    }
    
    // MARK: - Others
}