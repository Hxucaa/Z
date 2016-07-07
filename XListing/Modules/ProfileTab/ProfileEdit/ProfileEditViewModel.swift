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
    let nicknameField: Observable<FormField<String>>
    let whatsUpField: Observable<FormField<String>>
    let profileImageField: Observable<FormField<UIImage>>
    var formStatus: Observable<FormStatus> {
        return form.status
    }
    var submissionEnabled: Observable<Bool> {
        return form.submissionEnabled
    }

    // MARK: - Properties
    
    enum FieldName : String {
        case Nickname = "昵称"
        case WhatsUp = "What's Up"
        case ProfileImage = "头像"
    }
    
    private let form: Form

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
        
        
        let nicknameField = FormFieldFactory(
            name: FieldName.Nickname,
            initial: me
                .map { $0!.nickname },
            input: nicknameInput.asObservable()
        ) { value in
            guard let value = value else {
                return ValidationNEL<String, ValidationError>.Failure([ValidationError.Required])
            }
            
            let base = ValidationNEL<String -> String, ValidationError>.Success({ a in value })
            let rule: ValidationNEL<String, ValidationError> = value.characters.count >= 1 && value.characters.count <= 20 ?
                .Success(value) :
                .Failure([ValidationError.Custom(message: "昵称长度必须为1-20字符")])
            
            return base <*> rule
        }
        
        let whatsUpField = FormFieldFactory(
            name: FieldName.WhatsUp,
            initial: me
                .map { $0!.whatsUp },
            input: whatsUpInput.asObservable()
        ) { value in
            guard let value = value else {
                return ValidationNEL<String, ValidationError>.Success("")
            }
            
            let base = ValidationNEL<String -> String, ValidationError>.Success({ a in value })
            let rule: ValidationNEL<String, ValidationError> = value.characters.count <= 30 ?
                .Success(value) :
                .Failure([ValidationError.Custom(message: "What's Up 长度必须少于30字符")])
            
            return base <*> rule
        }
        
        let profileImageField = FormFieldFactory(
            name: FieldName.ProfileImage,
            initial: me
                .map { $0?.coverPhoto }
                .flatMap { profileImage -> Observable<UIImage?> in
                    guard let profileImage = profileImage else {
                        return Observable.just(UIImage(asset: UIImage.Asset.Profilepicture))
                    }
                    // FIXME: placeholder
                    return dep.imageService.getImage(NSURL(string: "http://2.bp.blogspot.com/-pATX0YgNSFs/VP-82AQKcuI/AAAAAAAALSU/Vet9e7Qsjjw/s1600/Cat-hd-wallpapers.jpg")!)
                        .map { Optional.Some($0) }
                        .catchErrorJustReturn(nil)
            },
            input: profileImageInput.asObservable()
        )
        
        form = Form(
            initialLoadTrigger: input.loadFormData,
            submitTrigger: input.submit.asObservable(),
            submitHandler: { (fields) -> Observable<FormStatus> in
                let nickname = fields[FieldName.Nickname.rawValue] as! FormField<String>
                let whatsUp = fields[FieldName.WhatsUp.rawValue] as! FormField<String>
                let profileImage = fields[FieldName.ProfileImage.rawValue] as! FormField<UIImage>
                return dep.meRepository.updateProfile(nickname.inputValue, whatsUp: whatsUp.inputValue, coverPhoto: profileImage.inputValue)
                    .map { $0 ? .Submitted : .Error }
            },
            formField: nicknameField, whatsUpField, profileImageField
        )
        
        self.nicknameField = nicknameField.output
        self.whatsUpField = whatsUpField.output
        self.profileImageField = profileImageField.output
        
        super.init(router: dep.router)
    }
}
