//
//  IDetailViewModel.swift
//  XListing
//
//  Created by Lance Zhu on 2015-04-15.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import SwiftTask
import ReactKit

public protocol IDetailViewModel : class {
    var business: BusinessViewModel! { get set }
    func goingToBusiness(business: BusinessViewModel, thisWeek: Bool, thisMonth: Bool, later: Bool) -> Task<Int, WantToGoDAO, NSError>
}