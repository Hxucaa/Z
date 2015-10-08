//
//  PhotoManagerViewController.swift
//  XListing
//
//  Created by Lance Zhu on 2015-10-07.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import UIKit
import ReactiveCocoa
import AVOSCloud
import Dollar
import Cartography

public final class PhotoManagerViewController : UIViewController {
    
    // MARK: - UI Controls
    
    // MARK: - Properties
    private var viewmodel: IPhotoManagerViewModel!
    
    // MARK: - Initializers
    
    // MARK: - Setups
    
    // MARK: - Bindings
    
    public func bindToViewModel(viewmodel: IPhotoManagerViewModel) {
        self.viewmodel = viewmodel
    }
}
