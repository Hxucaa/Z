//
//  LogInViewModel.swift
//  XListing
//
//  Created by Lance Zhu on 2015-04-23.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import Locksmith

public class AccountViewModel : IAccountViewModel {
    
    private let userService: IUserService
    
    public init(userService: IUserService) {
        self.userService = userService
        
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
                logIn(loginUser, password: loginPass)
            } else {
                // First time setup, generate random user and pass
                var username = NSUUID().UUIDString
                var password = NSUUID().UUIDString
                
                var user = UserDAO()
                user.username = username
                user.password = password
                
                // Sign up for PFUser account
                user.signUpInBackgroundWithBlock {
                    (succeeded: Bool, error: NSError?) -> Void in
                    if let error = error {
                        let errorString = error.userInfo?["error"] as? NSString
                        println(errorString)
                    } else {
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
                }
            }
        }
    }
    
    public func logIn(username: String, password: String) {
            userService.logIn(username, password: password)
            .success { user -> Void in
                println(user)
            }
            .failure { error, isCancelled -> Void in
                println(error)
            }
    }
}