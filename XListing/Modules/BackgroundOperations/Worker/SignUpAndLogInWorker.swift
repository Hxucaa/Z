//
//  SignUpAndLogInWorker.swift
//  XListing
//
//  Created by Lance Zhu on 2015-05-28.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import SwiftTask
import ReactKit
import AVOSCloud

public struct SignUpAndLogInWorker : ISignUpAndLogInWorker {
    
    private let userService: IUserService
    private let keychainService: IKeychainService
    
    public init(userService: IUserService, keychainService: IKeychainService) {
        self.userService = userService
        self.keychainService = keychainService
    }
    
    public func logInOrsignUpInBackground() {
        
        // Only enable this if you have trouble reigster/log in
//        keychainService.clearKeychain()
        
        
        if userService.isLoggedInAlready() {
            // User Already Logged in
            BOLogInfo("Current user logged in is " + userService.currentUser()!.username)
        }
        else {
            // Load credentials from Keychain
            let getCredentialsSignal = Stream<(username: String, password: String)>.fromTask(keychainService.loadUserCredentialsTask())
                |> catch { (error, isCancelled) -> Stream<(username: String, password: String)> in
                    // Generate random user and pass
                    let (username, password) = self.generateUsernameAndPassword()
                    
                    // Save new credentials to Keychain
                    return self.keychainService.saveUserCredentials(username, password: password)
                        // Load credentials from Keychain again
                        |> flatMap { success -> Stream<(username: String, password: String)> in
                            return self.keychainService.loadUserCredentials()
                    }
                }
                |> peek { (username: String, password: String) -> Void in
                    BOLogInfo("Username \(username) is loaded from Keychain.")
                }
                |> flatMap { (username, password) -> Stream<Bool> in
                    if self.keychainService.credentialsHaveRegistered() {
                        BOLogInfo("Log in user...")
                        let logInTask = self.userService.logIn(username, password: password)
                            .success { user -> Bool in
                                BOLogInfo("Operation succeed!")
                                return true
                            }
                            .failure({ (error, isCancelled) -> Bool in
                                BOLogInfo("Operation failed!")
                                return false
                            })
                        return Stream<Bool>.fromTask(logInTask)
                    }
                    else {
                        BOLogInfo("Sign up user...")
                        var user = User()
                        user.username = username
                        user.password = password
                        let signUpTask = self.userService.signUp(user)
                            .success { success -> Bool in
                                BOLogInfo("Operation succeed!")
                                return true
                            }
                            .failure({ (error, isCancelled) -> Bool in
                                println("Operation failed!")
                                return false
                            })
                        let updateHasRegisteredTask = signUpTask
                            .success { _ -> Task<Int, Bool, NSError> in
                                BOLogInfo("Status saved to Keychain!")
                                return self.keychainService.updateHasRegistered(true)
                        }
                        return Stream<Bool>.fromTask(updateHasRegisteredTask)
                    }
                }
            
            getCredentialsSignal ~> { _ in }
        }
    }

    private func generateUsernameAndPassword() -> (username: String, password: String) {
        return (username: NSUUID().UUIDString, password: NSUUID().UUIDString)
    }
}