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
    
    // MARK: - Variables
    
    
    // MARK: - Initializers
    public init() {

        isProfileImageValid <~ profileImage.producer
            .skip(1)
            .ignoreNil()
            .map { _ in true }
    }
    
    // MARK: - Setups
    
    // MARK: - Others
}