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
    
    // MARK: - View Models
    public let usernameAndPasswordViewModel = UsernameAndPasswordViewModel()
    public let nicknameViewModel = NicknameViewModel()
    public let genderPickerViewModel = GenderPickerViewModel()
    public let birthdayPickerViewModel = BirthdayPickerViewModel()
    public let photoViewModel = PhotoViewModel()
    
    // MARK: - Properties
    
    // MARK: Services
    private weak var accountNavigator: IAccountNavigator!
    private let meService: IMeService
    
    // MARK: Initializers
    public init(accountNavigator: IAccountNavigator, meService: IMeService) {
        self.meService = meService
        self.accountNavigator = accountNavigator
    }
    
    deinit {
        // Dispose signals before deinit.
        AccountLogVerbose("Sign Up View Model deinitializes.")
    }
    
    // MARK: Setup
    
    // MARK: Others
    public func signUp() -> SignalProducer<Bool, NSError> {
        return combineLatest(
            self.usernameAndPasswordViewModel.username.producer
                .ignoreNil(),
            self.usernameAndPasswordViewModel.password.producer
                .ignoreNil(),
            self.nicknameViewModel.nickname.producer
                .ignoreNil(),
            self.genderPickerViewModel.gender.producer
                .ignoreNil(),
            self.birthdayPickerViewModel.birthday.producer
                .ignoreNil(),
            self.photoViewModel.profileImage.producer
                .ignoreNil()
            )
            .promoteErrors(NSError)
            .flatMap(FlattenStrategy.Concat) { username, password, nickname, gender, birthday, profileImage in
                return self.meService.signUp(
                    username,
                    password: password,
                    nickname: nickname,
                    birthday: birthday,
                    gender: gender,
                    profileImage: profileImage
                )
            }
    }
    
    public func finishModule(callback: (CompletionHandler? -> ())? = nil) {
        accountNavigator.finishModule { handler in
            callback?(handler)
        }
    }
}