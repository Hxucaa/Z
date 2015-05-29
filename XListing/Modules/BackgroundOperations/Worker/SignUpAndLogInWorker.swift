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
        if userService.isLoggedInAlready() {
            // User Already Logged in
            println("Current user logged in is " + userService.currentUser()!.username)
        }
        else {

            // Load credentials from Keychain
            let getCredentialsSignal = keychainService.loadUserCredentials()
            
            let setupNewCredentialSignal = getCredentialsSignal
                // Catch load from Keychain error
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
            
            
            let signUpSignal = setupNewCredentialSignal
                // Sign up
                |> flatMap { (username, password) -> Stream<Bool> in
                    
                    var user = User()
                    user.username = username
                    user.password = password
                    
                    return self.userService.signUp(user)
                }
            
            // Handle error: username is taken
            let code = signUpSignal.errorInfo?.error?.code
            if code == kAVErrorUsernameTaken || code == kAVErrorUsernamePasswordMismatch {
                let signUpAgainSignal = signUpSignal
                    |> catch { (error, isCancelled) -> Stream<Bool> in
                        
                        return self.signUpWithCredentials { (username, password) -> Stream<Bool> in
                            return self.keychainService.saveUserCredentials(username, password: password)
                        }
                    }
            }
            
            // Log in when credentials are loaded from Keychain
            let logInSignal = getCredentialsSignal
                // Log in
                |> flatMap { (username, password) -> Stream<Bool> in
                    return self.userService.logIn(username, password: password)
                }
                // Catch log in error
                |>  catch { (error, isCancelled) -> Stream<Bool> in
//                    if error?.code == kAVErrorUserNotFound {
                    return self.signUpWithCredentials { (username, password) -> Stream<Bool> in
                        return self.keychainService.updateUserCredentials(username, password: password)
                    }
//                    }
                }
        }
    }
    
    private func signUpWithCredentials(credentialOperation: (username: String, password: String) -> Stream<Bool>) -> Stream<Bool> {
        // Generate random user and pass
        let (username, password) = self.generateUsernameAndPassword()
        
        // Update credentials in Keychain
        return credentialOperation(username: username, password: password)
            |> flatMap { success -> Stream<(username: String, password: String)> in
                return self.keychainService.loadUserCredentials()
            }
            // Try log in again
            |> flatMap { (username: String, password: String) -> Stream<Bool> in
                
                var user = User()
                user.username = username
                user.password = password
                
                return self.userService.signUp(user)
            }
    }

    private func generateUsernameAndPassword() -> (username: String, password: String) {
        return (username: NSUUID().UUIDString, password: NSUUID().UUIDString)
    }
}