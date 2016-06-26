//
//  ProfileEditViewModel.swift
//  XListing
//
//  Created by Lance Zhu on 2016-02-07.
//  Copyright (c) 2016 Lance Zhu. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxOptional
import Swiftz

final class ProfileEditViewModel : _BaseViewModel, ViewModelInjectable {
    
    // MARK: - Inputs
    let nicknameInput: PublishSubject<String?>
    let whatsUpInput: PublishSubject<String?>
    let profileImageInput: PublishSubject<UIImage?>
    
    // MARK: - Outputs
//    let nicknameField
    let nicknameField: Observable<FormField<String>>
    let whatsUpField: Observable<FormField<String>>
    let profileImageField: Observable<FormField<UIImage>>
    let formStatus: Driver<FormStatus>
    let submissionEnabled: Driver<Bool>

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
        
        let nicknameInput = PublishSubject<String?>()
        let whatsUpInput = PublishSubject<String?>()
        let profileImageInput = PublishSubject<UIImage?>()
        
        self.nicknameInput = nicknameInput
        self.whatsUpInput = whatsUpInput
        self.profileImageInput = profileImageInput
        
        let me = input.loadFormData
            .flatMap { _ in dep.meRepository.rx_me() }
            .shareReplay(1)
        
        let nicknameField = me
            .map { $0!.nickname }
            .concat(nicknameInput.asObservable())
            .scan(nil) { acc, current -> FormField<String>? in
                guard let acc = acc else {
                    return FormField(name: "昵称", initialValue: current) { value in
                        guard let value = value else {
                            return ValidationNEL<String, ValidationError>.Failure([ValidationError.Required])
                        }
                        
                        let base = ValidationNEL<String -> String, ValidationError>.Success({ a in value })
                        let rule: ValidationNEL<String, ValidationError> = value.length >= 1 && value.length <= 20 ? .Success(value) : .Failure([ValidationError.Custom(message: "昵称长度必须为1-20字符")])
                        
                        return base <*> rule
                    }
                }
                
                return acc.onChange(current)
            }
            .filterNil()
            .shareReplay(1)
            .observeOn(MainScheduler.instance)
            .debug("nickname")
        
        let whatsUpField = me
            .map { $0!.whatsUp }
            .concat(whatsUpInput.asObservable())
            .scan(nil) { acc, current -> FormField<String>? in
                guard let acc = acc else {
                    return FormField(name: "What's Up", initialValue: current) { value in
                        guard let value = value else {
                            return ValidationNEL<String, ValidationError>.Success("")
                        }
                        
                        let base = ValidationNEL<String -> String, ValidationError>.Success({ a in value })
                        let rule: ValidationNEL<String, ValidationError> = value.length <= 30 ? .Success(value) : .Failure([ValidationError.Custom(message: "What's Up 长度必须少于30字符")])
                        
                        return base <*> rule
                    }
                }
                
                return acc.onChange(current)
            }
            .filterNil()
            .shareReplay(1)
            .observeOn(MainScheduler.instance)
        
        let profileImageField = me
            .map { $0?.coverPhoto }
            .flatMap { profileImage -> Observable<UIImage?> in
                guard profileImage != nil else {
                    return Observable.just(UIImage(asset: UIImage.Asset.Profilepicture))
                }
                //                return dep.imageService.getImage(coverPhoto)
                return Observable.just(UIImage(asset: UIImage.Asset.Profilepicture))
            }
            .concat(profileImageInput.asObservable())
            .scan(nil) { acc, current -> FormField<UIImage>? in
                guard let acc = acc else {
                    return FormField(name: "头像", initialValue: current)
                }
                
                return acc.onChange(current)
            }
            .filterNil()
            .shareReplay(1)
            .observeOn(MainScheduler.instance)
        
        formStatus = Observable.of(
            input.loadFormData
                .map { _ in .Loading },
            input.submit
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
                            return dep.meRepository.rx_updateProfile(nickname.inputValue, whatsUp: whatsUp.inputValue, coverPhoto: profileImage.inputValue)
                                .map { $0 ? .Submitted : .Error }
                                .startWith(.Submitting)
                        }
                }
        )
            .merge()
//            .startWith(.Loading)
            .debug("formStatus")
            .asDriver(onErrorJustReturn: .Fatal)
        
        
        
        let submissionEnabled = [
            formStatus
                .debug("submission formStatus")
                .map {
                    switch $0 {
                    case .Awaiting: return true
                    case .Submitted: return true
                    default: return false
                    }
                }
                .debug(),
            Observable.combineLatest(
                nicknameField,
                whatsUpField,
                profileImageField
            ) { ($0, $1, $2) }
                .map {
                    $0.0.valid && $0.1.valid && $0.2.valid && ($0.0.dirty || $0.1.dirty || $0.2.dirty)
                }
                .asDriver(onErrorJustReturn: false)
            ]
            .combineLatest {
                $0.and
            }
            // submission is disabled initially
            .startWith(false)
        
        
        self.submissionEnabled = submissionEnabled
        self.nicknameField = nicknameField
        self.whatsUpField = whatsUpField
        self.profileImageField = profileImageField
        
        super.init(router: dep.router)

    }
}
