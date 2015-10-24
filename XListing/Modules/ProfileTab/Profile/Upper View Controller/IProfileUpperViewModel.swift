//
//  IProfileUpperViewModel.swift
//  XListing
//
//  Created by Lance Zhu on 2015-10-07.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import ReactiveCocoa

public protocol IProfileUpperViewModel : class {
    
    // MARK: - Properties
    
    // MARK: ViewModels
    var profileHeaderViewModel: PropertyOf<IProfileHeaderViewModel?> { get }
    
    // MARK: - API
    func getUserInfo() -> SignalProducer<Void, NSError>

}