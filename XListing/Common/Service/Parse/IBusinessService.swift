//
//  IBusinessService.swift
//  XListing
//
//  Created by Lance Zhu on 2015-04-03.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import SwiftTask

public protocol IBusinessService {
    func save(business: BusinessDAO) -> Task<Int, Bool, NSError>
    func getFirst(query: PFQuery?) -> Task<Int, BusinessDAO?, NSError>
    func findBy(query: PFQuery?) -> Task<Int, [BusinessDAO], NSError>
}