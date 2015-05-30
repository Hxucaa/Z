//
//  iKeychainService.swift
//  XListing
//
//  Created by William Qi on 2015-05-24.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import SwiftTask
import ReactKit

public protocol IKeychainService {
    func clearKeychain() -> Bool
    func credentialsHaveRegistered() -> Bool
    func updateHasRegistered(registered: Bool) -> Task<Int, Bool, NSError>
    func saveUserCredentials(username: String, password: String) -> Stream<Bool>
    func loadUserCredentialsTask() -> Task<Int, (username: String, password: String), NSError>
    func loadUserCredentials() -> Stream<(username: String, password: String)>
    func updateUserCredentials(username: String, password: String) -> Stream<Bool>
}