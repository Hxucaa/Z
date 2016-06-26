//
//  SignUpViewModel.swift
//  XListing
//
//  Created by Lance Zhu on 2015-06-09.
//  Copyright (c) 2016 Lance Zhu. All rights reserved.
//

import Foundation
import ReactiveCocoa
import AVOSCloud

final class SignUpViewModel : ISignUpViewModel {
    
    // MARK: - Inputs
    
    // MARK: - Outputs
    
    // MARK: - View Models
    let usernameAndPasswordViewModel = UsernameAndPasswordViewModel()
    let nicknameViewModel = NicknameViewModel()
    let genderPickerViewModel = GenderPickerViewModel()
    let birthdayPickerViewModel = BirthdayPickerViewModel()
    let photoViewModel = PhotoViewModel()
    
    // MARK: - Properties
    
    // MARK: Services
    private weak var router: IRouter!
    private let meRepository: IMeRepository
    
    // MARK: Initializers
    init(dep: (router: IRouter, meRepository: IMeRepository)) {
        self.router = dep.router
        self.meRepository = dep.meRepository
    }
    
    // MARK: Setup
    
    // MARK: Others
    func signUp() -> SignalProducer<Bool, NetworkError> {
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
            .promoteErrors(NetworkError)
            .flatMap(FlattenStrategy.Concat) { username, password, nickname, gender, birthday, profileImage in
                return self.meRepository.signUp(
                    username,
                    password: password,
                    nickname: nickname,
                    birthday: birthday,
                    gender: gender,
                    profileImage: profileImage
                )
            }
    }
    
    func finishModule(callback: (CompletionHandler? -> ())? = nil) {
        router.finishModule { handler in
            callback?(handler)
        }
    }
}