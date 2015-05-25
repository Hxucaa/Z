//
//  LogInViewModel.swift
//  XListing
//
//  Created by Lance Zhu on 2015-04-23.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import SwiftTask

public class AccountViewModel : IAccountViewModel {
    
    private let userService: IUserService
    private let keychainService: IKeychainService
    
    public init(userService: IUserService, keychainService: IKeychainService) {
        self.userService = userService
        self.keychainService = keychainService
        logInOrsignUpInBackground()
    }
    
    private func logInOrsignUpInBackground() {
        if UserService.isLoggedInAlready() {
            // User Already Logged in
            println("Current user logged in is " + UserService.currentUser()!.username)
        } else {
            // Load data from Keychain
            let (usernameData, userError) = keychainService.loadData("XListingUser", service: "XListing")
            let (passwordData, passError) = keychainService.loadData("XListingPassword", service: "XListing")
            
            if usernameData != nil {
                // User Account created previously
                let loginUser = usernameData!.valueForKey("username") as! String
                let loginPass = passwordData!.valueForKey("password") as! String
                userService.logIn(loginUser, password: loginPass)
                println("Logged in as " + loginUser)
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
                    
                    // Save username to Keychain
                    let keychainUserError = self.keychainService.storeStringData("username", data: username, account: "XListingUser", service: "XListing")
                    if keychainUserError != nil {
                        println("Error Saving Username to Keychain:\n" + String(stringInterpolationSegment: keychainUserError))
                    } else {
                        println("Username " + username + " successfully saved to keychain.")
                    }
                    
                    // Save password to Keychain
                    let keychainPasswordError = self.keychainService.storeStringData("password", data: password, account: "XListingPassword", service: "XListing")
                    if keychainPasswordError != nil {
                        println("Error Saving Password to Keychain:\n" + String(stringInterpolationSegment: keychainPasswordError))
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
    
    public func updateBirthday(birthday : NSDate) {
        // Format the string
        let formatter = NSDateFormatter()
        formatter.dateFormat = "M/d/yyyy"
        let dateString = formatter.stringFromDate(birthday)
        
        // Save to Parse
        var user = User.currentUser()
        user["birthday"] = birthday
        
        user.saveInBackgroundWithBlock {
            (success: Bool, error: NSError?) -> Void in
            if (success) {
                println("User birthday updated to " + dateString)
            } else {
                println("Error when attempting to update birthday")
            }
        }
    }
    
    public func getDisplayName() -> String {
        var user = User.currentUser()
        return String(stringInterpolationSegment: user["displayName"])
    }
    
    public func updateDisplayName(displayName : String) {
        var user = User.currentUser()
        user["displayName"] = displayName
        user.saveInBackgroundWithBlock {
            (success: Bool, error: NSError?) -> Void in
            if (success) {
                println("User display name updated to " + displayName)
            } else {
                println("Error when attempting to update display name")
            }
        }
    }
    
    public func updateProfilePicture(image: UIImage) {
        var user = User.currentUser()
        
        let imageData = UIImagePNGRepresentation(image)
        let imageName = User.currentUser().username + ".png"
        //let imageFile = PFFile(name: imageName, data:imageData)
        
        //user["profilePicture"] = imageFile
        user.saveInBackgroundWithBlock {
            (success: Bool, error: NSError?) -> Void in
            if (success) {
                println("Profile picture updated successfully")
            } else {
                println("Error when attempting to update profile picture")
            }
        }
    }

    
}














