//
//  iKeychainService.swift
//  XListing
//
//  Created by William Qi on 2015-05-24.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import ReactKit

public protocol IKeychainService {
    func saveUserCredentials(username: String, password: String) -> Stream<Bool>
    func loadUserCredentials() -> Stream<(username: String, password: String)>
    func updateUserCredentials(username: String, password: String) -> Stream<Bool>
}