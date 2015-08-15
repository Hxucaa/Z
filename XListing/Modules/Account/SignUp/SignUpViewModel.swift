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
    private let username = MutableProperty<String?>(nil)
    private let password = MutableProperty<String?>(nil)
    private let nickname = MutableProperty<String?>(nil)
    private let birthday = MutableProperty<NSDate?>(nil)
    private let gender = MutableProperty<Gender?>(nil)
    private let photo = MutableProperty<UIImage?>(nil)
    
    // MARK: - Outputs
    public let areAllProfileInputsPresent = MutableProperty<Bool>(false)
    public let areSignUpInputsPresent = MutableProperty<Bool>(false)
    
    // MARK: - View Models
    public lazy var usernameAndPasswordViewModel: UsernameAndPasswordViewModel = { [unowned self] in
        let viewmodel = UsernameAndPasswordViewModel(submit: self.signUp)
        
        self.username <~ viewmodel.validUsernameSignal
            |> map { Optional<String>($0) }
        
        self.password <~ viewmodel.validPasswordSignal
            |> map { Optional<String>($0) }
        
        return viewmodel
    }()
    
    public lazy var nicknameViewModel: NicknameViewModel = { [unowned self] in
        let viewmodel = NicknameViewModel()
        
        self.nickname <~ viewmodel.validNicknameSignal
            |> map { Optional<String>($0) }
        
        return viewmodel
    }()
    
    public lazy var genderPickerViewModel: GenderPickerViewModel = { [unowned self] in
        let viewmodel = GenderPickerViewModel()
        
        self.gender <~ viewmodel.validGenderSignal
            |> map { Optional<Gender>($0) }
        
        return viewmodel
    }()
    
    public lazy var birthdayPickerViewModel: BirthdayPickerViewModel = { [unowned self] in
        let viewmodel = BirthdayPickerViewModel()
        
        self.birthday <~ viewmodel.validBirthdaySignal
            |> map { Optional<NSDate>($0) }
        
        return viewmodel
    }()
    
    public lazy var photoViewModel: PhotoViewModel = { [unowned self] in
        let viewmodel = PhotoViewModel()
        
        self.photo <~ viewmodel.validProfileImageSignal
            |> map { Optional<UIImage>($0) }
        
        return viewmodel
    }()
    
    // MARK: - Properties
    private weak var accountNavigator: IAccountNavigator!
    private let userService: IUserService
    private lazy var allProfileInputs: SignalProducer<(String, NSDate, UIImage, Gender), NoError> = combineLatest(self.nickname.producer |> ignoreNil, self.birthday.producer |> ignoreNil, self.photo.producer |> ignoreNil, self.gender.producer |> ignoreNil)
    private lazy var allSignUpInputs: SignalProducer<(String, String), NoError> = combineLatest(self.username.producer |> ignoreNil, self.password.producer |> ignoreNil)
    
    // MARK: Initializers
    public init(accountNavigator: IAccountNavigator, userService: IUserService) {
        self.userService = userService
        self.accountNavigator = accountNavigator
        
        areAllProfileInputsPresent <~ allProfileInputs
            |> map { _ in true }
        
        areSignUpInputsPresent <~ allSignUpInputs
            |> map { _ in true }
        
    }
    
    deinit {
        // Dispose signals before deinit.
        AccountLogVerbose("Sign Up View Model deinitializes.")
    }
    
    // MARK: Setup
    
    // MARK: Others
    public var signUp: SignalProducer<Bool, NSError> {
        return self.areSignUpInputsPresent.producer
            // only allow TRUE value
            |> filter { $0 }
            |> flatMap(.Concat) { _ in self.allSignUpInputs }
            |> promoteErrors(NSError)
            |> flatMap(FlattenStrategy.Merge) { username, password -> SignalProducer<Bool, NSError> in
                let user = User()
                user.username = username
                user.password = password
                return self.userService.signUp(user)
        }
    }
    
    public var updateProfile: SignalProducer<Bool, NSError> {
        return self.areAllProfileInputsPresent.producer
            // only allow TRUE value
            |> filter { $0 }
            |> promoteErrors(NSError)
            |> flatMap(.Concat) { _ in self.userService.currentLoggedInUser() }
            |> flatMap(.Concat) { user -> SignalProducer<Bool, NSError> in
                return self.allProfileInputs
                    |> promoteErrors(NSError)
                    |> flatMap(.Latest) { (nickname, birthday, profileImage, gender) -> SignalProducer<Bool, NSError> in
                        let imageData = UIImagePNGRepresentation(profileImage)
                        let file = AVFile.fileWithName("profile.png", data: imageData) as! AVFile
                        user.nickname = nickname
                        user.birthday = birthday
                        user.profileImg = file
                        user.gender = gender.rawValue
                        
                        return self.userService.save(user)
                }
        }
    }
    
    public func goToFeaturedModule(_ callback: (CompletionHandler? -> ())? = nil) {
        accountNavigator.goToFeaturedModule { handler in
            callback?(handler)
        }
    }
}