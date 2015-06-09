//
//  EditProfileViewController.swift
//  XListing
//
//  Created by Lance Zhu on 2015-06-09.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import UIKit
import ReactKit
import Foundation

public final class EditProfileViewController : UIViewController {
    private var viewmodel: EditProfileViewModel!
    
    public func bindToViewModel(viewmodel: EditProfileViewModel) {
        self.viewmodel = viewmodel
    }
}