//
//  DetailModuleDelegate.swift
//  XListing
//
//  Created by Lance Zhu on 2015-04-24.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation

public protocol FeaturedListInterfaceToDetailInterfaceDelegate : class {
    /**
    Push DetailViewController to NavigationControllerw.
    
    :param: businessViewModel A BusinessViewModel.
    */
    func pushInterface(businessViewModel: BusinessViewModel)
}