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
    public let photo = MutableProperty<UIImage?>(nil)
    
    // MARK: - Output
    public let isPhotoValid = MutableProperty<Bool>(false)
    
    // MARK: - Variables
    public let validPhotoSignal: SignalProducer<UIImage, NoError>
    
    
    // MARK: - Initializers
    public init() {
        validPhotoSignal = photo.producer
            |> ignoreNil

        isPhotoValid <~ validPhotoSignal
            |> map { _ in true }
    }
    
    // MARK: - Setups
    
    // MARK: - Others
}