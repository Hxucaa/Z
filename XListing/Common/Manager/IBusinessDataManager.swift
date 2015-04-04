//
//  IBusinessDataManager.swift
//  XListing
//
//  Created by Lance Zhu on 2015-04-03.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import SwiftTask

public protocol IBusinessDataManager {
    func save(business: BusinessEntity) -> Task<Int, Bool, NSError>
    func getFirst(query: PFQuery) -> Task<Int, BusinessEntity?, NSError>
    func findBy(query: PFQuery) -> Task<Int, [BusinessEntity], NSError>
}