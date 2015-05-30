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
private let hasRegistered = "hasRegistered"
private let yes = "YES"
private let no = "NO"

public struct KeychainService : IKeychainService {
    
    public func clearKeychain() -> Bool {
        let t = Locksmith.deleteDataForUserAccount(account)
        return t != nil ? true : false
    }
    
    public func loadHasRegistered() -> Stream<Bool> {
        let task = Task<Int, Bool, NSError> { fulfill, reject in
            let (data, error) = self.loadData()
            if let error = error {
                reject(error)
            }
            else {
                if let didRegistered = data?[hasRegistered] as? String {
                    if didRegistered == yes {
                        fulfill(true)
                    }
                    else {
                        fulfill(false)
                    }
                }
                else {
                    reject(NSError(domain: "KeychainService", code: 800, userInfo: ["Error" : "Data retrieved from Keychain is invalid"]))
                }
            }
        }
        return Stream<Bool>.fromTask(task)
    }
    
    public func credentialsHaveRegistered() -> Bool {
        let (data, error) = self.loadData()
        if let didRegistered = data?[hasRegistered] as? String {
            if didRegistered == yes {
                return true
            }
            else {
                return false
            }
        }
        else {
            return false
        }
    }
    
    public func updateHasRegistered(registered: Bool) -> Task<Int, Bool, NSError> {
        
        let task = Task<Int, Bool, NSError> { fulfill, reject in
            let error = self.saveData([hasRegistered: registered ? yes : no])
            if let error = error {
                reject(error)
            }
            else {
                fulfill(true)
            }
        }
        return task
    }
    
    private func saveUserCredentials(username: String, password: String) -> Task<Int, Bool, NSError> {
        return Task<Int, Bool, NSError> { fulfill, reject in
            let error = self.saveData([usernameKey : username, passwordKey : password, hasRegistered: no])
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
    
    public func loadUserCredentialsTask() -> Task<Int, (username: String, password: String), NSError> {
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
        return Stream<(username: String, password: String)>.fromTask(loadUserCredentialsTask())
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
