//
//  SignUpViewModel.swift
//  XListing
//
//  Created by Lance Zhu on 2016-07-06.
//  Copyright (c) 2016 Lance Zhu. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Swiftz

final class SignUpViewModel : _BaseViewModel, ISignUpViewModel, ViewModelInjectable {
    
    // MARK: - Inputs
    let inputs: (
        username: PublishSubject<String>,
        password: PublishSubject<String>,
        nickname: PublishSubject<String>,
        birthday: PublishSubject<NSDate>,
        gender: PublishSubject<Gender>,
        profileImage: PublishSubject<UIImage>
    )
    
    // MARK: - Outputs
    var usernameField: Observable<FieldState<String>> {
        return form.fieldOutput(FieldName.Username, type: String.self)!
    }
    var passwordField: Observable<FieldState<String>> {
        return form.fieldOutput(FieldName.Password, type: String.self)!
    }
    var profileImageField: Observable<FieldState<UIImage>> {
        return form.fieldOutput(FieldName.ProfileImage, type: UIImage.self)!
    }
    var nicknameField: Observable<FieldState<String>> {
        return form.fieldOutput(FieldName.Nickname, type: String.self)!
    }
    var birthdayField: Observable<FieldState<NSDate>> {
        return form.fieldOutput(FieldName.Birthday, type: NSDate.self)!
    }
    var genderField: Observable<FieldState<Gender>> {
        return form.fieldOutput(FieldName.Gender, type: Gender.self)!
    }
    let pickerUpperLimit: NSDate
    let pickerLowerLimit: NSDate
    var formStatus: Observable<FormStatus> {
        return form.status
    }
    var submissionEnabled: Observable<Bool> {
        return form.submissionEnabled
    }
    
    // MARK: - Properties
    private enum FieldName : String {
        case Username = "Username"
        case Password = "Password"
        case Nickname = "Nickname"
        case Birthday = "Birthday"
        case Gender = "Gender"
        case ProfileImage = "ProfileImage"
    }
    private let form: Form
    
    private let usernameAndPasswordValidator: UsernameAndPasswordValidator
    
    // MARK: Services
    private let meRepository: IMeRepository
    
    // MARK: Initializers
    typealias Dependency = (router: IRouter, meRepository: IMeRepository)
    
    typealias Token = Void
    
    typealias Input = (submitTrigger: ControlEvent<Void>, dummy: Void)
    
    init(dep: Dependency, token: Token, input: Input) {
        self.meRepository = dep.meRepository
        
        inputs = (
            username: PublishSubject<String>(),
            password: PublishSubject<String>(),
            nickname: PublishSubject<String>(),
            birthday: PublishSubject<NSDate>(),
            gender: PublishSubject<Gender>(),
            profileImage: PublishSubject<UIImage>()
        )
        
        func 年龄上限() -> NSDate {
            let currentDate = NSDate()
            return calDate(currentDate, age: Constants.MIN_AGE)
        }
        
        func 年龄下限() -> NSDate {
            let currentDate = NSDate()
            return calDate(currentDate, age: Constants.MAX_AGE)
        }
        
        func calDate(currentDate: NSDate, age: Int) -> NSDate {
            let calendar = NSCalendar.currentCalendar()
            let components = calendar.components([NSCalendarUnit.Day, NSCalendarUnit.Month, NSCalendarUnit.Year], fromDate: currentDate)
            let currentYear = components.year
            let currentMonth = components.month
            let currentDay = components.day
            
            let ageComponents = NSDateComponents()
            ageComponents.year = currentYear - age
            ageComponents.month = currentMonth
            ageComponents.day = currentDay
            return calendar.dateFromComponents(ageComponents)!
        }
        
        pickerUpperLimit = NSDate(timeInterval: -1, sinceDate: 年龄上限())
        pickerLowerLimit = NSDate(timeInterval: 1, sinceDate: 年龄下限())
        
        let upvm = UsernameAndPasswordValidator()
        usernameAndPasswordValidator = upvm
        
        
        let usernameField = FieldFactory(
            name: FieldName.Username,
            required: true,
            initialValue: nil,
            input: inputs.username.asObservable(),
            validation: upvm.validateUsername
        )
        
        let passwordField = FieldFactory(
            name: FieldName.Password,
            required: true,
            initialValue: nil,
            input: inputs.password.asObservable(),
            validation: upvm.validatePassword
        )
        
        let profileImageField = FieldFactory(
            name: FieldName.ProfileImage,
            required: true,
            initialValue: UIImage(asset: UIImage.Asset.Profilepicture),
            input: inputs.profileImage.asObservable()
        )
        
        let nicknameField = FieldFactory(
            name: FieldName.Nickname,
            required: true,
            initialValue: nil,
            input: inputs.nickname.asObservable()
        ) { value -> ValidationNEL<String, ValidationError> in
            let base = ValidationNEL<String -> String, ValidationError>.Success({ a in value })
            let rule1: ValidationNEL<String, ValidationError> = value.characters.count > 1 && value.characters.count <= 10 ?
                .Success(value) :
                .Failure([ValidationError.Custom(message: "长度必须为1-10个字符")])
            
            return base <*> rule1
        }
        
        let birthdayField = FieldFactory<NSDate>(
            name: FieldName.Birthday,
            required: true,
            initialValue: nil,
            input: inputs.birthday.asObservable()
        ) { value in
            
            let base = ValidationNEL<NSDate -> NSDate, ValidationError>.Success({ a in value })
            let rule1: ValidationNEL<NSDate, ValidationError> = (value.compare(年龄上限()) == .OrderedAscending) && (value.compare(年龄下限()) == .OrderedDescending) ?
                .Success(value) :
                .Failure([ValidationError.Custom(message: "最小年龄17岁")])
            
            return base <*> rule1
        }
        
        let genderField = FieldFactory(
            name: FieldName.Gender,
            required: true,
            initialValue: nil,
            input: inputs.gender.asObservable()
        )
        
        form = Form(
            submitTrigger: input.submitTrigger.asObservable(),
            submitHandler: { fields -> Observable<FormStatus> in
                guard let
                    username = (fields[FieldName.Username.rawValue] as! FieldState<String>).inputValue,
                    password = (fields[FieldName.Password.rawValue] as! FieldState<String>).inputValue,
                    nickname = (fields[FieldName.Nickname.rawValue] as! FieldState<String>).inputValue,
                    birthday = (fields[FieldName.Birthday.rawValue] as! FieldState<NSDate>).inputValue,
                    gender = (fields[FieldName.Gender.rawValue] as! FieldState<Gender>).inputValue,
                    profileImage = (fields[FieldName.ProfileImage.rawValue] as! FieldState<UIImage>).inputValue
                    else {
                        return Observable.just(.Error)
                }
                
                // TODO: fix placeholders
                return dep.meRepository.signUp(
                    username,
                    password: password,
                    nickname: nickname,
                    birthday: birthday,
                    gender: gender,
                    profileImage: profileImage
                    )
                    .map { _ in .Submitted }
                    .catchErrorJustReturn(.Error)
            },
            formField: usernameField, passwordField, profileImageField, nicknameField, birthdayField, genderField
        )
        
        super.init(router: dep.router)

    }
    // MARK: Others
    
    func finishModule(callback: (CompletionHandler? -> ())? = nil) {
        router.finishModule { handler in
            callback?(handler)
        }
    }
}