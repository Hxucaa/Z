//
//  ISignUpViewModel.swift
//  XListing
//
//  Created by Lance Zhu on 2016-03-28.
//  Copyright © 2016 ZenChat. All rights reserved.
//

import Foundation
import ReactiveCocoa

protocol ISignUpViewModel {
    var usernameAndPasswordViewModel: UsernameAndPasswordViewModel { get }
    var nicknameViewModel: NicknameViewModel { get }
    var genderPickerViewModel: GenderPickerViewModel { get }
    var birthdayPickerViewModel: BirthdayPickerViewModel { get }
    var photoViewModel: PhotoViewModel { get }
    
    func signUp() -> SignalProducer<Bool, NetworkError>
    func finishModule(callback: (CompletionHandler? -> ())?)
}
