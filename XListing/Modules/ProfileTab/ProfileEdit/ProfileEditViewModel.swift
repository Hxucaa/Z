//
//  ProfileEditViewModel.swift
//  XListing
//
//  Created by Lance Zhu on 2016-02-07.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import ReactiveCocoa
import AVOSCloud
import Swiftz

public final class ProfileEditViewModel {
    
    // MARK: - Fields
    private let _nicknameField = MutableProperty<FormField<String>?>(nil)
    public var nicknameField: AnyProperty<FormField<String>?> {
        return AnyProperty(_nicknameField)
    }
    private let _whatsUpField = MutableProperty<FormField<String>?>(nil)
    public var whatsUpField: AnyProperty<FormField<String>?> {
        return AnyProperty(_whatsUpField)
    }
    private let _profileImageField = MutableProperty<FormField<UIImage>?>(nil)
    public var profileImageField: AnyProperty<FormField<UIImage>?> {
        return AnyProperty(_profileImageField)
    }
    
    // MARK: - Outputs
    public var formValid: SignalProducer<Bool, NoError> {
        return combineLatest(
            nicknameField.producer
                .ignoreNil()
                .flatMap(FlattenStrategy.Concat) { $0.valid.producer },
            whatsUpField.producer
                .ignoreNil()
                .flatMap(FlattenStrategy.Concat) { $0.valid.producer },
            profileImageField.producer
                .ignoreNil()
                .flatMap(FlattenStrategy.Concat) { $0.valid.producer }
            )
            .map { $0.0 && $0.1 && $0.2 }
    }
    
    public var formFormattedErrors: SignalProducer<String, NoError> {
        return combineLatest(
            nicknameField.producer
                .ignoreNil()
                .flatMap(FlattenStrategy.Concat) { $0.formattedErrors() },
            whatsUpField.producer
                .ignoreNil()
                .flatMap(FlattenStrategy.Concat) { $0.formattedErrors() },
            profileImageField.producer
                .ignoreNil()
                .flatMap(FlattenStrategy.Concat) { $0.formattedErrors() }
        )
            .map { [$0.0, $0.1, $0.2].filter { $0 != nil }.reduce("") { "\($0)\n\($1)" } }
    }
    
    // MARK: - Properties
    
    // MARK: - Services
    private let meService: IMeService
    private let imageService: IImageService
    
    // MARK: - Initializers
    
    public init(meService: IMeService, imageService: IImageService) {
        self.meService = meService
        self.imageService = imageService
    }
    
    // MARK: - Actions
    
    public func getInitialValues() -> SignalProducer<Void, NSError> {
        
        return meService.currentLoggedInUser()
            .on(next: { me in
                print(me.nickname)
                print(me.whatsUp)
                print(me.coverPhoto)
                self._nicknameField.value = FormField(name: "Nickname", initialValue: me.nickname) { value in
                    
                    let base = ValidationNEL<String -> String, ValidationError>.Success({ a in value })
                    let rule: ValidationNEL<String, ValidationError> = value.length >= 1 && value.length <= 20 ? .Success(value) : .Failure([ValidationError.Custom(message: "昵称长度必须为1-20字符")])
                    
                    return base <*> rule
                }
                
                self._whatsUpField.value = FormField(name: "What's Up", initialValue: me.whatsUp) { value in
                    
                    let base = ValidationNEL<String -> String, ValidationError>.Success({ a in value })
                    let rule: ValidationNEL<String, ValidationError> = value.length <= 30 ? .Success(value) : .Failure([ValidationError.Custom(message: "What's Up 长度必须少于30字符")])
                    
                    return base <*> rule
                }
            })
            .flatMap(FlattenStrategy.Concat) { me -> SignalProducer<UIImage?, NSError> in
                if let coverPhoto = me.coverPhoto {
                    return self.imageService.getImage(coverPhoto)
                        .map { Optional.Some($0) }
                }
                else {
                    return SignalProducer<UIImage?, NSError>(value: nil)
                }
            }
            .on(next: { photo in
                if let photo = photo {
                    self._profileImageField.value = FormField(name: "Profile Image", initialValue: photo)
                }
                else {
                    self._profileImageField.value = FormField(name: "Profile Image")
                }
            })
            .map { _ in }
    }
    
    public func updateProfile() -> SignalProducer<Bool, NSError> {
        return combineLatest(
            nicknameField.producer
                .ignoreNil()
                .flatMap(FlattenStrategy.Concat) {
                    $0.value.producer
                },
            whatsUpField.producer
                .ignoreNil()
                .flatMap(FlattenStrategy.Concat) {
                    $0.value.producer
                },
            profileImageField.producer
                .ignoreNil()
                .flatMap(FlattenStrategy.Concat) {
                    $0.value.producer
                }
            )
            .promoteErrors(NSError)
            .flatMap(FlattenStrategy.Merge) { nickname, whatsUp, image -> SignalProducer<Bool, NSError> in
                
                let me = self.meService.currentUser!
                if let nickname = nickname {
                    me.nickname = nickname
                }
                me.whatsUp = whatsUp
                if let image = image, data = UIImagePNGRepresentation(image) {
                    me.setCoverPhoto("profile.png", data: data)
                }
                return self.meService.save(me)
            }
    }
}