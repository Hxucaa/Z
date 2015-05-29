//
//  KeychainService.swift
//  XListing
//
//  Created by William Qi on 2015-05-24.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import SwiftTask
import ReactKit
import Locksmith

private let account = "XListingCredentials"
private let usernameKey = "username"
private let passwordKey = "password"

public struct KeychainService : IKeychainService {
    
    private func saveUserCredentials(username: String, password: String) -> Task<Int, Bool, NSError> {
        return Task<Int, Bool, NSError> { fulfill, reject in
            let error = self.saveData([usernameKey : username, passwordKey : password])
            if let error = error {
                reject(error)
            }
            else {
                fulfill(true)
            }
        }
    }
    
    public func saveUserCredentials(username: String, password: String) -> Stream<Bool> {
        return Stream<Bool>.fromTask(saveUserCredentials(username, password: password))
    }
    
    private func loadUserCredentials() -> Task<Int, (username: String, password: String), NSError> {
        return Task<Int, (username: String, password: String), NSError> { fulfill, reject in
            let (data, error) = self.loadData()
            if let error = error {
                reject(error)
            }
            else {
                if let username = data?[usernameKey] as? String,
                    password = data?[passwordKey] as? String {
                        fulfill((username: username, password: password))
                }
                else {
                    reject(NSError(domain: "KeychainService", code: 800, userInfo: ["Error" : "Data retrieved from Keychain is invalid"]))
                }
            }
        }
    }
    
    public func loadUserCredentials() -> Stream<(username: String, password: String)> {
        return Stream<(username: String, password: String)>.fromTask(loadUserCredentials())
    }
    
    private func updateUserCredentials(username: String, password: String) -> Task<Int, Bool, NSError> {
        return Task<Int, Bool, NSError> { fulfill, reject in
            let error = self.updateData([usernameKey : username, passwordKey : password])
            if let error = error {
                reject(error)
            }
            else {
                fulfill(true)
            }
        }
    }
    
    public func updateUserCredentials(username: String, password: String) -> Stream<Bool> {
        return Stream<Bool>.fromTask(updateUserCredentials(username, password: password))
    }
    
    private func loadData() -> (NSDictionary?, NSError?) {
        return Locksmith.loadDataForUserAccount(account)
    }
    
    private func saveData(dict: Dictionary<String, String>) -> NSError? {
        return Locksmith.saveData(dict, forUserAccount: account)
    }
    
    private func updateData(dict: Dictionary<String, String>) -> NSError? {
        return Locksmith.updateData(dict, forUserAccount: account)
    }
}
