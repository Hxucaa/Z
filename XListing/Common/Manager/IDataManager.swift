//
//  IDataManager.swift
//  XListing
//
//  Created by Lance Zhu on 2015-04-08.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import SwiftTask

public protocol IDataManager {
    func getFeaturedBusiness() -> Task<Int, Void, NSError>
    func getBusiness()
}