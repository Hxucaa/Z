//
//  PublicProfileViewModel.swift
//  XListing
//
//  Created by Bruce Li on 2015-10-26.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import ReactiveCocoa
import AVOSCloud
import Dollar
import ReactiveArray

public protocol PublicProfileNavigator : class {
    func presentFullScreenImage(imageURL: NSURL, animated: Bool, completion: CompletionHandler?)
}

public final class PublicProfileViewModel : IPublicProfileViewModel {
    
    // MARK: - Properties
    public let profilePhotoCellViewModel: ProfilePhotoCellViewModel
    public let profileUpperViewModel: ProfileUpperViewModel
    
    // MARK: Variables
    public weak var navigator: PublicProfileNavigator!
    
    // MARK: Services
    
    private let userService: IUserService
    private let imageService: IImageService
    
    public init(userService: IUserService, imageService: IImageService) {
        self.userService = userService
        self.imageService = imageService
        
        profilePhotoCellViewModel = ProfilePhotoCellViewModel(imageService: imageService, image: nil)
        profileUpperViewModel = ProfileUpperViewModel(userService: userService, imageService: imageService)
    }
    
    public func presentFullScreenImageModule(index: Int, animated: Bool, completion: CompletionHandler? = nil) {
        let url = NSURL(string: "blah")!
        navigator.presentFullScreenImage(url, animated: animated, completion: completion)
    }
    
}