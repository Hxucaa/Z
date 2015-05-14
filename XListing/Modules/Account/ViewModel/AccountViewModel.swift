//
//  LogInViewModel.swift
//  XListing
//
//  Created by Lance Zhu on 2015-04-23.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import Locksmith
import SwiftTask

public class AccountViewModel : IAccountViewModel {
    
    private let userService: IUserService
    
    public init(userService: IUserService) {
        self.userService = userService
        logInOrsignUpInBackground()
    }
    
    private func logInOrsignUpInBackground() {
        if UserService.isLoggedInAlready() {
            // User Already Logged in
            println("User is already logged in!")
        } else {
            // Load data from Keychain
            let (usernameData, userError) = Locksmith.loadDataForUserAccount("XListingUser", inService: "XListing")
            let (passwordData, passError) = Locksmith.loadDataForUserAccount("XLstingPassword", inService: "XListing")
            
            if usernameData != nil {
                // User Account created previously
                let loginUser = usernameData!.valueForKey("username") as! String
                let loginPass = passwordData!.valueForKey("password") as! String
                userService.logIn(loginUser, password: loginPass)
            } else {
                // First time setup, generate random user and pass
                var username = NSUUID().UUIDString
                var password = NSUUID().UUIDString
                
                var user = User()
                user.username = username
                user.password = password
                
                // Sign up for a user account
                userService.signUp(user).success { success -> Void in
                    println("Sign Up Successful with username " + username)
                    Locksmith.clearKeychain()
                    
                    // Save username to Keychain
                    let keychainUserError = Locksmith.saveData(["username": username], forUserAccount: "XListingUser", inService: "XListing")
                    if keychainUserError != nil {
                        println("Error Saving Username to Keychain:\n" + String(stringInterpolationSegment: keychainUserError))
                    } else {
                        println("Username " + username + " successfully saved to keychain.")
                    }
                    
                    // Save password to Keychain
                    let keychainPasswordError = Locksmith.saveData(["password": password], forUserAccount: "XListingPassword", inService: "XListing")
                    if keychainPasswordError != nil {
                        println("Error Saving Password to Keychain:\n" + String(stringInterpolationSegment: keychainPasswordError))
                        println("Problematic password was " + password)
                    } else {
                        println("Password " + password + " successfully saved to keychain.")
                    }

                }
                .failure { (error, isCancelled) -> Void in
                    if let error = error {
                        println(error)
                    }
                    else {
                        println(isCancelled)
                    }
                }
            }
        }
    }
}