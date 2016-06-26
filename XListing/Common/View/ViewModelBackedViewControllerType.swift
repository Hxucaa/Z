//
//  ViewModelBackedViewControllerType.swift
//  XListing
//
//  Created by Lance Zhu on 2016-03-29.
//  Copyright © 2016 Lance Zhu. All rights reserved.
//

import Foundation

protocol ViewModelBackedViewControllerType {
    associatedtype ViewModelType
    
    func bindToViewModel(viewmodel: ViewModelType)
}