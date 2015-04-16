//
//  IRealmWritter.swift
//  XListing
//
//  Created by Lance Zhu on 2015-04-09.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import Realm

public protocol IRealmWritter {
    func saveBusinessDaosToRealm(realm: RLMRealm, withDaoArray daoArr: [BusinessDAO])
}