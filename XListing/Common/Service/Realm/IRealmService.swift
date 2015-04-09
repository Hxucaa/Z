//
//  IRealmService.swift
//  XListing
//
//  Created by Lance Zhu on 2015-04-09.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import Realm

public protocol IRealmService {
    var defaultRealm: RLMRealm! { get }
    func deleteDefaultRealm() -> Void
}