//
//  LogInViewModel.swift
//  XListing
//
//  Created by Lance Zhu on 2015-06-09.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import SwiftTask
import ReactKit
import AVOSCloud

public final class LogInViewModel : NSObject {
    
    // MARK: - Services
    private let userService: IUserService
    
    // MARK: - Input Receivers
    public var username: String?
    public var password: String?
    
    // MARK: - Input Observer Signals
    private var usernameSignal: Stream<String?>!
    private var passwordSignal: Stream<String?>!
    
    // MARK: - Latest Valid Input Signals
    private var transformedUsernameProducer: (Void -> Stream<String?>)!
    private var transformedPasswordProducer: (Void -> Stream<String?>)!
    private var allInputsValidProducer: (Void -> Stream<Bool?>)!
    
    // MARK: - Output Signals
    public private(set) var allInputsValidSignal: Stream<Bool?>!
    
    // MARK: - Initializers
    
    public required init(userService: IUserService) {
        self.userService = userService
        
        super.init()
        
        setupUsername()
        setupPassword()
        setupAllInputsValid()
    }
    
    // MARK: - Setup Functions
    
    private func setupUsername() {
        usernameSignal = KVO.stream(self, "username")
            |> map { $0 as? String }
            // TODO: add regex to allow only a subset of characters
            |> filter { count($0!) > 0 }
        
        transformedUsernameProducer = self.usernameSignal |>> replay(capacity: 1)
        
    }
    
    private func setupPassword() {
        passwordSignal = KVO.stream(self, "password")
            |> map { $0 as? String }
        
        transformedPasswordProducer = self.passwordSignal |>> replay(capacity: 1)
    }
    
    private func setupAllInputsValid() {
        allInputsValidSignal = [
            usernameSignal,
            passwordSignal
        ]
            |> merge2All
            |> map { (values, changedValues) -> Bool? in
                if let v1 = values[0], v2 = values[1] {
                    return true
                }
                else {
                    return false
                }
            }
            |> startWith(false)
        
        allInputsValidProducer = self.allInputsValidSignal |>> replay(capacity: 1)
    }
    
    // MARK: - Public API
    public var logIn: Void -> Stream<Bool?> {
        return {
            return self.allInputsValidProducer()
                |> flatMap { success -> Stream<[String?]> in
                    if success! {
                        return [
                                self.transformedUsernameProducer(),
                                self.transformedPasswordProducer()
                            ]
                            |> zipAll
                    }
                    else {
                        return Stream.error(NSError(domain: "LogInViewModel", code: 899, userInfo: nil))
                    }
                }
                |> flatMap {
                    Stream<User>.fromTask(self.userService.logIn($0[0]!, password: $0[1]!))
                }
                |> map { value -> Bool? in
                    return value == nil ? false : true
                }
        }
    }
}
