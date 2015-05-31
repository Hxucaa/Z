//
//  IWantToGoService.swift
//  XListing
//
//  Created by Lance Zhu on 2015-04-29.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import SwiftTask

public protocol IWantToGoService : class {
    func findBy(var query: PFQuery?) -> Task<Int, [WantToGo], NSError>
    func goingToBusiness(businessId: String, thisWeek: Bool, thisMonth: Bool, later: Bool) -> Task<Int, WantToGo, NSError>
}