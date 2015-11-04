//
//  PhotoViewModel.swift
//  XListing
//
//  Created by Lance Zhu on 2015-08-07.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import ReactiveCocoa

public final class PhotoViewModel {
    
    // MARK: - Input
    public let profileImage = MutableProperty<UIImage?>(UIImage(named: ImageAssets.profilepicture))
    
    // MARK: - Output
    public let isProfileImageValid = MutableProperty<Bool>(false)
    /// Data of this signal comes from `SignUpViewModel`
    public let areAllProfileInputsPresent = MutableProperty<Bool>(false)
    
    // MARK: - Variables
    public let validProfileImageSignal: SignalProducer<UIImage, NoError>
    
    
    // MARK: - Initializers
    public init(updateProfile: SignalProducer<Bool, NSError>) {
        self.updateProfile = updateProfile
        
        validProfileImageSignal = profileImage.producer
            .skip(1)
            .ignoreNil()

        isProfileImageValid <~ validProfileImageSignal
            .map { _ in true }
    }
    
    // MARK: - Setups
    
    // MARK: - Others
    public let updateProfile: SignalProducer<Bool, NSError>
}