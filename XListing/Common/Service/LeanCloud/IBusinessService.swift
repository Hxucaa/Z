//
//  IBusinessService.swift
//  XListing
//
//  Created by Lance Zhu on 2015-04-03.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import SwiftTask
import AVOSCloud

public protocol IBusinessService {
    func save(business: Business) -> Task<Int, Bool, NSError>
    func getFirst(query: AVQuery?) -> Task<Int, Business?, NSError>
    func findBy(query: AVQuery?) -> Task<Int, [Business], NSError>
}