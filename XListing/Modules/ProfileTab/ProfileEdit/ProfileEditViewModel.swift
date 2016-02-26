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

// TODO: Make a new abstraction "Form", which is responsible for registering fields and managing their state.

public final class ProfileEditViewModel {
    
    // MARK: - Fields
    private let _nicknameField = MutableProperty<RequiredFormField<String>?>(nil)
    public var nicknameField: AnyProperty<RequiredFormField<String>?> {
        return AnyProperty(_nicknameField)
    }
    private let _whatsUpField = MutableProperty<OptionalFormField<String>?>(nil)
    public var whatsUpField: AnyProperty<OptionalFormField<String>?> {
        return AnyProperty(_whatsUpField)
    }
    private let _profileImageField = MutableProperty<OptionalFormField<UIImage>?>(nil)
    public var profileImageField: AnyProperty<OptionalFormField<UIImage>?> {
        return AnyProperty(_profileImageField)
    }
    
    // MARK: - Outputs
    public func isFormValid() -> SignalProducer<Bool, NoError> {
        return combineLatest(
                nicknameField.producer
                    .ignoreNil()
                    .flatMap(.Latest) { $0.valid.producer },
                whatsUpField.producer
                    .ignoreNil()
                    .flatMap(.Latest) { $0.valid.producer },
                profileImageField.producer
                    .ignoreNil()
                    .flatMap(.Latest) { $0.valid.producer }
            )
            .map { $0.0 && $0.1 && $0.2 }
    }
    
    public func formFormattedErrors() -> SignalProducer<String?, NoError> {
        return combineLatest(
                nicknameField.producer
                    .ignoreNil()
                    .map { $0.formattedErrors() },
                whatsUpField.producer
                    .ignoreNil()
                    .map { $0.formattedErrors() },
                profileImageField.producer
                    .ignoreNil()
                    .map { $0.formattedErrors() }
            )
            .map {
                [$0.0, $0.1, $0.2].filter { $0 != nil }.map { $0! }.joinWithSeparator("\n")
            }
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
            .flatMap(FlattenStrategy.Concat) { me in
                SignalProducer<Me, NSError> { observer, disposable in
                    
                    self._nicknameField.value = RequiredFormField(name: "昵称", initialValue: me.nickname) { value in
                        
                        let base = ValidationNEL<String -> String, ValidationError>.Success({ a in value })
                        let rule: ValidationNEL<String, ValidationError> = value.length >= 1 && value.length <= 20 ? .Success(value) : .Failure([ValidationError.Custom(message: "昵称长度必须为1-20字符")])
                        
                        return base <*> rule
                    }
                    
                    self._whatsUpField.value = OptionalFormField(name: "What's Up", initialValue: me.whatsUp) { value in
                        
                        let base = ValidationNEL<String -> String, ValidationError>.Success({ a in value })
                        let rule: ValidationNEL<String, ValidationError> = value.length <= 30 ? .Success(value) : .Failure([ValidationError.Custom(message: "What's Up 长度必须少于30字符")])
                        
                        return base <*> rule
                    }
                    
                    observer.sendNext(me)
                    observer.sendCompleted()
                }
            }
            .flatMap(FlattenStrategy.Concat) { me -> SignalProducer<Void, NSError> in
                guard let coverPhoto = me.coverPhoto else {
                    return SignalProducer<Void, NSError>(value: ())
                }
                
                return self.imageService.getImage(coverPhoto)
                    .map { Optional.Some($0) }
                    .flatMap(FlattenStrategy.Concat) { image in
                        SignalProducer<Void, NSError> { observer, disposable in
                            self._profileImageField.value = OptionalFormField(name: "头像", initialValue: image)
                            
                            observer.sendNext(())
                            observer.sendCompleted()
                        }
                    }
            }
    }
    
    public func updateProfile() -> SignalProducer<Bool, NSError> {
        return combineLatest(
                nicknameField.producer
                    .ignoreNil()
                    .flatMap(FlattenStrategy.Concat) {
                        zip($0.dirty.producer, $0.value.producer)
                    },
                whatsUpField.producer
                    .ignoreNil()
                    .flatMap(FlattenStrategy.Concat) {
                        zip($0.dirty.producer, $0.value.producer)
                    },
                profileImageField.producer
                    .ignoreNil()
                    .flatMap(FlattenStrategy.Concat) {
                        zip($0.dirty.producer, $0.value.producer)
                    }
            )
            .promoteErrors(NSError)
            .flatMap(FlattenStrategy.Merge) { nickname, whatsUp, image -> SignalProducer<Bool, NSError> in
                
                let me = self.meService.currentUser!
                if let nicknameValue = nickname.1 where nickname.0 {
                    me.nickname = nicknameValue
                }
                if whatsUp.0 {
                    me.whatsUp = whatsUp.1
                }
                if let imageValue = image.1, data = UIImagePNGRepresentation(imageValue) where image.0 {
                    me.setCoverPhoto("profile.png", data: data)
                }
                return self.meService.save(me)
            }
    }
}