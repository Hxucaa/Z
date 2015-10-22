//
//  PhotoManagerViewModel.swift
//  XListing
//
//  Created by Lance Zhu on 2015-10-07.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation

public final class PhotoManagerViewModel : IPhotoManagerViewModel {
    
    // MARK: - Properties
    public let profilePhotoCellViewModel: ProfilePhotoCellViewModel
    
    // MARK: Services
    
    private let userService: IUserService
    private let imageService: IImageService
    
    public init(userService: IUserService, imageService: IImageService) {
        self.userService = userService
        self.imageService = imageService
        
        profilePhotoCellViewModel = ProfilePhotoCellViewModel(imageService: imageService, image: nil)
    }
}