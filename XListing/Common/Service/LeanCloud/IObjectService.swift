//
//  IObjectService.swift
//  XListing
//
//  Created by Lance Zhu on 2015-04-18.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import SwiftTask
import AVOSCloud

public protocol IObjectService {
    func save<T: AVObject>(obj: T) -> Task<Int, Bool, NSError>
    func getFirst(query: PFQuery?) -> Task<Int, PFObject, NSError>
}