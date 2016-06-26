//
//  PhotoViewModel.swift
//  XListing
//
//  Created by Lance Zhu on 2015-08-07.
//  Copyright (c) 2016 Lance Zhu. All rights reserved.
//

import Foundation
import ReactiveCocoa

public final class PhotoViewModel {
    
    // MARK: - Input
    public let profileImage = MutableProperty<UIImage?>(UIImage(asset: .Profilepicture))
    
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