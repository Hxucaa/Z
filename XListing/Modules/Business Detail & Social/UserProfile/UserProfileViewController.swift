//
//  UserProfileViewController.swift
//  XListing
//
//  Created by Lance Zhu on 2015-09-04.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import UIKit
import SDWebImage
import ReactiveCocoa
import Dollar
import Cartography

public final class UserProfileViewController : XUIViewController {
    
    // MARK: - UI Controls
    
    // MARK: - Properties
    private var viewmodel: IUserProfileViewModel!
    
    // MARK: - Setups
    
    
    // MARK: - Bindings
    public func bindToViewModel(viewmodel: IUserProfileViewModel) {
        self.viewmodel = viewmodel
    }
    
    // MARK: - Others
}