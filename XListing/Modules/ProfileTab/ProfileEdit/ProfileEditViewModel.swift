//
//  ProfileEditViewModel.swift
//  XListing
//
//  Created by Lance Zhu on 2016-02-07.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Swiftz

// TODO: Make a new abstraction "Form", which is responsible for registering fields and managing their state.

//struct ProfileForm {
//    let nicknameField: RequiredFormField<String>
//    let whatsUpField: RequiredFormField<String>
//    let profileImageField: RequiredFormField<UIImage>
//}

enum FormStatus {
    case Loading
    case Awaiting
    case Error
    case Submitting
    case Submitted
}

final class ProfileEditViewModel : _BaseViewModel, ViewModelInjectable {

    // MARK: - Fields
//    private let _nicknameField = MutableProperty<RequiredFormField<String>?>(nil)
//    var nicknameField: AnyProperty<RequiredFormField<String>?> {
//        return AnyProperty(_nicknameField)
//    }
//    private let _whatsUpField = MutableProperty<OptionalFormField<String>?>(nil)
//    var whatsUpField: AnyProperty<OptionalFormField<String>?> {
//        return AnyProperty(_whatsUpField)
//    }
//    private let _profileImageField = MutableProperty<RequiredFormField<UIImage>?>(nil)
//    var profileImageField: AnyProperty<RequiredFormField<UIImage>?> {
//        return AnyProperty(_profileImageField)
//    }
//
//    // MARK: - Outputs
//    func isFormValid() -> SignalProducer<Bool, NoError> {
//        return combineLatest(
//                nicknameField.producer
//                    .ignoreNil()
//                    .flatMap(.Latest) { $0.valid.producer },
//                whatsUpField.producer
//                    .ignoreNil()
//                    .flatMap(.Latest) { $0.valid.producer },
//                profileImageField.producer
//                    .ignoreNil()
//                    .flatMap(.Latest) { $0.valid.producer }
//            )
//            .map { $0.0 && $0.1 && $0.2 }
//    }
//
//    func formFormattedErrors() -> SignalProducer<String?, NoError> {
//        return combineLatest(
//                nicknameField.producer
//                    .ignoreNil()
//                    .map { $0.formattedErrors() },
//                whatsUpField.producer
//                    .ignoreNil()
//                    .map { $0.formattedErrors() },
//                profileImageField.producer
//                    .ignoreNil()
//                    .map { $0.formattedErrors() }
//            )
//            .map {
//                [$0.0, $0.1, $0.2].filter { $0 != nil }.map { $0! }.joinWithSeparator("\n")
//            }
//    }
    
//    let profileForm: Driver<ProfileForm>
    // MARK: - Inputs
    let nicknameInput: PublishSubject<String>
    let whatsUpInput: PublishSubject<String?>
    let profileImageInput: PublishSubject<UIImage>
    
    // MARK: - Outputs
    let nicknameField: Observable<FormField<String>>
    let whatsUpField: Observable<FormField<String>>
    let profileImageField: Observable<FormField<UIImage>>
    let formStatus: Observable<FormStatus>
    let submissionDisabled: Observable<Bool>

    // MARK: - Properties

    // MARK: - Services
    private let meRepository: IMeRepository
    private let imageService: IImageService

    // MARK: - Initializers
    typealias Dependency = (router: IRouter, meRepository: IMeRepository, imageService: IImageService)
    typealias Token = Void
    typealias Input = (loadFormData: Observable<Void>, submit: ControlEvent<Void>)

    init(dep: Dependency, token: Token, input: Input) {
        meRepository = dep.meRepository
        imageService = dep.imageService
        
        let nicknameInput = PublishSubject<String>()
        let whatsUpInput = PublishSubject<String?>()
        let profileImageInput = PublishSubject<UIImage>()
        
        self.nicknameInput = nicknameInput
        self.whatsUpInput = whatsUpInput
        self.profileImageInput = profileImageInput
        
        let me = input.loadFormData
            .flatMap { _ in dep.meRepository.rx_me() }
        
        let nicknameField = me
            .map { $0!.nickname }
            .concat(nicknameInput.asObservable())
            .map {
                FormField(name: "昵称", initialValue: $0) { value in
                    guard let value = value else {
                        return ValidationNEL<String, ValidationError>.Failure([ValidationError.Required])
                    }
                    
                    let base = ValidationNEL<String -> String, ValidationError>.Success({ a in value })
                    let rule: ValidationNEL<String, ValidationError> = value.length >= 1 && value.length <= 20 ? .Success(value) : .Failure([ValidationError.Custom(message: "昵称长度必须为1-20字符")])
                    
                    return base <*> rule
                }
            }
        //            .subscribe(nicknameField.asObserver())
        
        let whatsUpField = me
            .map { $0!.whatsUp }
            .concat(whatsUpInput.asObservable())
            .map {
                FormField(name: "What's Up", initialValue: $0) { value in
                    guard let value = value else {
                        return ValidationNEL<String, ValidationError>.Success("")
                    }
                    
                    let base = ValidationNEL<String -> String, ValidationError>.Success({ a in value })
                    let rule: ValidationNEL<String, ValidationError> = value.length <= 30 ? .Success(value) : .Failure([ValidationError.Custom(message: "What's Up 长度必须少于30字符")])
                    
                    return base <*> rule
                }
        }
        //            .subscribe(whatsUpField.asObserver())
        
        let profileImageField = me
            .map { $0?.coverPhoto }
            .flatMap { profileImage -> Observable<UIImage> in
                guard profileImage != nil else {
                    return Observable.just(UIImage(asset: UIImage.Asset.Profilepicture))
                }
                //                return dep.imageService.getImage(coverPhoto)
                return Observable.just(UIImage(asset: UIImage.Asset.Profilepicture))
            }
            .concat(profileImageInput.asObservable())
            .map { FormField(name: "头像", initialValue: UIImage?($0)) }
        //            .subscribe(profileImageField.asObserver())
        
        let submissionDisabled = Observable.combineLatest(
            nicknameField,
            whatsUpField,
            profileImageField
        ) { ($0, $1, $2) }
            .map { $0.0.invalid || $0.1.invalid || $0.2.invalid }
        
        self.submissionDisabled = submissionDisabled
        
        formStatus = me
            .map { _ in }
            .concat(input.submit)
            .flatMap {
                Observable.combineLatest(
                    nicknameField
                        .filter { $0.isUserInput },
                    whatsUpField
                        .filter { $0.isUserInput },
                    profileImageField
                        .filter { $0.isUserInput }
                ) { ($0, $1, $2) }
                .flatMap { (nickname, whatsUp, profileImage) -> Observable<FormStatus> in
                    guard nickname.valid && whatsUp.valid && profileImage.valid else {
                        return Observable.just(.Error)
                    }
                    guard nickname.dirty || whatsUp.dirty || profileImage.dirty else {
                        return Observable.just(.Awaiting)
                    }
                    return dep.meRepository.rx_updateProfile(nickname.value.value, whatsUp: whatsUp.value.value, coverPhoto: profileImage.value.value)
                        .map { $0 ? .Submitted : .Error }
                        .startWith(.Submitting)
                }
            }
            .startWith(.Loading)
        
        self.nicknameField = nicknameField
        self.whatsUpField = whatsUpField
        self.profileImageField = profileImageField
        
        super.init(router: dep.router)

    }
    
//    func updateProfile() -> Observable<Bool> {
//    }

    // MARK: - Actions

//    func getInitialValues() -> SignalProducer<Void, NSError> {
//        let me = meRepository.me()!
//        
//        return SignalProducer<Me, NSError> { observer, disposable in
//            
//            self._nicknameField.value = RequiredFormField(name: "昵称", initialValue: me.nickname) { value in
//                
//                let base = ValidationNEL<String -> String, ValidationError>.Success({ a in value })
//                let rule: ValidationNEL<String, ValidationError> = value.length >= 1 && value.length <= 20 ? .Success(value) : .Failure([ValidationError.Custom(message: "昵称长度必须为1-20字符")])
//                
//                return base <*> rule
//            }
//            
//            self._whatsUpField.value = OptionalFormField(name: "What's Up", initialValue: me.whatsUp) { value in
//                
//                let base = ValidationNEL<String -> String, ValidationError>.Success({ a in value })
//                let rule: ValidationNEL<String, ValidationError> = value.length <= 30 ? .Success(value) : .Failure([ValidationError.Custom(message: "What's Up 长度必须少于30字符")])
//                
//                return base <*> rule
//            }
//            
//            observer.sendNext(me)
//            observer.sendCompleted()
//            }
//            .flatMap(FlattenStrategy.Concat) { me -> SignalProducer<Void, NSError> in
//                guard let coverPhoto = me.coverPhoto else {
//                    return SignalProducer<Void, NSError>(value: ())
//                }
//
//                return self.imageService.getImage(coverPhoto)
//                    .map { Optional.Some($0) }
//                    .flatMap(FlattenStrategy.Concat) { image in
//                        SignalProducer<Void, NSError> { observer, disposable in
//                            self._profileImageField.value = RequiredFormField(name: "头像", initialValue: image)
//
//                            observer.sendNext(())
//                            observer.sendCompleted()
//                        }
//                    }
//            }
//    }

//    func updateProfile() -> SignalProducer<Bool, NSError> {
//        return combineLatest(
//                nicknameField.producer
//                    .ignoreNil()
//                    .flatMap(FlattenStrategy.Concat) {
//                        zip($0.dirty.producer, $0.value.producer)
//                    },
//                whatsUpField.producer
//                    .ignoreNil()
//                    .flatMap(FlattenStrategy.Concat) {
//                        zip($0.dirty.producer, $0.value.producer)
//                    },
//                profileImageField.producer
//                    .ignoreNil()
//                    .flatMap(FlattenStrategy.Concat) {
//                        zip($0.dirty.producer, $0.value.producer)
//                    }
//            )
//            .promoteErrors(NSError)
//            .flatMap(FlattenStrategy.Merge) { nickname, whatsUp, image -> SignalProducer<Bool, NSError> in
//
//                let me = self.meRepository
//                if let nicknameValue = nickname.1 where nickname.0 {
//                    me.nickname = nicknameValue
//                }
//                if whatsUp.0 {
//                    me.whatsUp = whatsUp.1
//                }
//                if let imageValue = image.1, data = UIImagePNGRepresentation(imageValue) where image.0 {
//                    me.setCoverPhoto("profile.png", data: data)
//                }
//                return self.meService.save(me)
//            }
//    }
}
