//
//  IFeaturedListPresenter.swift
//  XListing
//
//  Created by Lance Zhu on 2015-03-24.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import SwiftTask

protocol IFeaturedListPresenter {
    func getList() -> Task<Int, [FeaturedListDisplayData], NSError>
}