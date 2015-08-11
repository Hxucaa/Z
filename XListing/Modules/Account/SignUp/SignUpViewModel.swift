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
    
    // MARK: Input
    private let nickname = MutableProperty<String?>(nil)
    private let birthday = MutableProperty<NSDate>(NSDate())
    private let gender = MutableProperty<Gender?>(nil)
    private let photo = MutableProperty<UIImage?>(nil)
    
    // MARK: Output
    public let allInputsValid = MutableProperty<Bool>(false)
    
    // MARK: Variables
    public lazy var usernameAndPasswordViewModel: UsernameAndPasswordViewModel = { [unowned self] in
        let viewmodel = UsernameAndPasswordViewModel()
        
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
        
        return viewmodel
    }()
    
    public lazy var photoViewModel: PhotoViewModel = { [unowned self] in
        let viewmodel = PhotoViewModel()
        
        self.photo <~ viewmodel.validProfileImageSignal
            |> map { Optional<UIImage>($0) }
        
        return viewmodel
    }()
    
    private let userService: IUserService
    
    // MARK: - API
    public var signUp: SignalProducer<Bool, NSError> {
        return self.allInputsValid.producer
            // only allow TRUE value
            |> filter { $0 }
            |> flatMap(.Concat) { _ in combineLatest(self.usernameAndPasswordViewModel.username.producer, self.usernameAndPasswordViewModel.password.producer ) }
            |> promoteErrors(NSError)
            |> flatMap(FlattenStrategy.Merge) { username, password -> SignalProducer<Bool, NSError> in
                let user = User()
                user.username = username
                user.password = password
//                return self.userService.signUp(user)
                return SignalProducer<Bool, NSError> { sink, disposable in
                    sendNext(sink, true)
                }
        }
    }
    
    public var updateProfile: SignalProducer<Bool, NSError> {
        return self.allInputsValid.producer
            // only allow TRUE value
            |> filter { $0 }
            |> promoteErrors(NSError)
            |> flatMap(.Latest) { _ in self.userService.currentLoggedInUser() }
            |> flatMap(FlattenStrategy.Merge) { user -> SignalProducer<Bool, NSError> in
                return combineLatest(self.nickname.producer, self.birthday.producer, self.photo.producer |> ignoreNil, self.gender.producer |> ignoreNil)
                    |> promoteErrors(NSError)
                    |> flatMap(.Latest) { (nickname, birthday, profileImage, gender) -> SignalProducer<Bool, NSError> in
                        let imageData = UIImagePNGRepresentation(profileImage)
                        let file = AVFile.fileWithName("profile.png", data: imageData) as! AVFile
                        user.nickname = nickname
                        user.birthday = birthday
                        user.profileImg = file
                        user.gender = gender.rawValue
                        user.ageGroup = ""
                        user.horoscope = ""
                        return self.userService.save(user)
                }
        }
    }
    
    // MARK: Initializers
    public init(userService: IUserService) {
        self.userService = userService
        
    }
    
    // MARK: Setup
    
    // MARK: Others
}