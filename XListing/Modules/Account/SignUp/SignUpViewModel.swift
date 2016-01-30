//
//  SignUpViewModel.swift
//  XListing
//
//  Created by Lance Zhu on 2015-06-09.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import ReactiveCocoa
import AVOSCloud

public final class SignUpViewModel {
    
    // MARK: - Inputs
    
    // MARK: - Outputs
    public var areAllInputsPresent: SignalProducer<Bool, NoError> {
        return allSignUpInputs
            .map { _ in true }
    }
    
    // MARK: - View Models
    public let usernameAndPasswordViewModel = UsernameAndPasswordViewModel()
    
    public let nicknameViewModel = NicknameViewModel()
    
    public let genderPickerViewModel = GenderPickerViewModel()
    
    public let birthdayPickerViewModel = BirthdayPickerViewModel()
    
    public let photoViewModel = PhotoViewModel()
    
    // MARK: - Properties
    private lazy var allSignUpInputs: SignalProducer<(String, String, String, Gender, NSDate, UIImage), NoError> = zip(
        self.usernameAndPasswordViewModel.validUsernameSignal,
        self.usernameAndPasswordViewModel.validPasswordSignal,
        self.nicknameViewModel.validNicknameSignal,
        self.genderPickerViewModel.validGenderSignal,
        self.birthdayPickerViewModel.validBirthdaySignal,
        self.photoViewModel.validProfileImageSignal
    )
    
    // MARK: Services
    private weak var accountNavigator: IAccountNavigator!
    private let userService: IUserService
    
    // MARK: Initializers
    public init(accountNavigator: IAccountNavigator, userService: IUserService) {
        self.userService = userService
        self.accountNavigator = accountNavigator
        
//        areAllProfileInputsPresent <~ allProfileInputs
//            .map { _ in true }
//        
//        areSignUpInputsPresent <~ allSignUpInputs
//            .map { _ in true }
        
    }
    
    deinit {
        // Dispose signals before deinit.
        AccountLogVerbose("Sign Up View Model deinitializes.")
    }
    
    // MARK: Setup
    
    // MARK: Others
    public func signUp() -> SignalProducer<Bool, NSError> {
        return allSignUpInputs
            .promoteErrors(NSError)
            .flatMap(FlattenStrategy.Merge) { username, password, nickname, gender, birthday, profileImage -> SignalProducer<Bool, NSError> in
                let user = User()
                
                user.username = username
                user.password = password
                user.nickname = nickname
                user.birthday = birthday
                let imageData = UIImagePNGRepresentation(profileImage)
                user.setCoverPhoto("profile.png", data: imageData!)
                user.gender = gender
                
                return self.userService.signUp(user)
        }
    }
    
//    private var updateProfile: SignalProducer<Bool, NSError> {
//        return self.areAllProfileInputsPresent.producer
//            // only allow TRUE value
//            .filter { $0 }
//            .promoteErrors(NSError)
//            .flatMap(.Concat) { _ in self.userService.currentLoggedInUser() }
//            .flatMap(.Concat) { user -> SignalProducer<Bool, NSError> in
//                return self.allProfileInputs
//                    .promoteErrors(NSError)
//                    .flatMap(.Latest) { (nickname, birthday, profileImage, gender) -> SignalProducer<Bool, NSError> in
//                        let imageData = UIImagePNGRepresentation(profileImage)
//                        user.nickname = nickname
//                        user.birthday = birthday
//                        user.setCoverPhoto("profile.png", data: imageData!)
//                        if let gender = self.gender.value {
//                            user.gender = gender
//                        }
//                        
//                        return self.userService.save(user)
//                }
//        }
//    }
    
    public func finishModule(callback: (CompletionHandler? -> ())? = nil) {
        accountNavigator.finishModule { handler in
            callback?(handler)
        }
    }
}