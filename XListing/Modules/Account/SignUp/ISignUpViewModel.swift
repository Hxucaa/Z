//
//  ISignUpViewModel.swift
//  XListing
//
//  Created by Lance Zhu on 2016-07-06.
//  Copyright © 2016 Lance Zhu. All rights reserved.
//

import Foundation
import RxSwift

protocol ISignUpViewModel {
    
    var inputs: (
        username: PublishSubject<String>,
        password: PublishSubject<String>,
        nickname: PublishSubject<String>,
        birthday: PublishSubject<NSDate>,
        gender: PublishSubject<Gender>,
        profileImage: PublishSubject<UIImage>
    ) { get }
    
    // MARK: - Outputs
    var usernameField: Observable<FormField<String>> { get }
    var passwordField: Observable<FormField<String>> { get }
    var profileImageField: Observable<FormField<UIImage>> { get }
    var nicknameField: Observable<FormField<String>> { get }
    var birthdayField: Observable<FormField<NSDate>> { get }
    var genderField: Observable<FormField<Gender>> { get }
    var pickerUpperLimit: NSDate { get }
    var pickerLowerLimit: NSDate { get }
    var formStatus: Observable<FormStatus> { get }
    var submissionEnabled: Observable<Bool> { get }
    func finishModule(callback: (CompletionHandler? -> ())?)
}
