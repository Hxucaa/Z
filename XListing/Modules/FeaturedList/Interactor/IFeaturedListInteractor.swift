//
//  IFeaturedListInteractor.swift
//  XListing
//
//  Created by Lance Zhu on 2015-03-24.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import SwiftTask

protocol IFeaturedListInteractor {
    func getFeaturedList() -> Task<Int, [BusinessDomain], NSError>
}