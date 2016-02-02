//
//  ProfileUpperViewModel.swift
//  XListing
//
//  Created by Lance Zhu on 2015-10-07.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import ReactiveCocoa

public final class ProfileUpperViewModel : IProfileUpperViewModel {
    
    // MARK: - Properties
    // MARK: Services
    private let meService: IMeService
    private let imageService: IImageService
    
    // MARK: ViewModels
    
    private let _profileHeaderViewModel = MutableProperty<IProfileHeaderViewModel?>(nil)
    public var profileHeaderViewModel: AnyProperty<IProfileHeaderViewModel?> {
        return AnyProperty(_profileHeaderViewModel)
    }
    
    // MARK: Variables
    private var user: User?
    
    public init(meService: IMeService, imageService: IImageService) {
        self.meService = meService
        self.imageService = imageService
        
    }
    
    // MARK: - API
    
    public func getUserInfo() -> SignalProducer<Void, NSError> {
        return self.meService.currentLoggedInUser()
            .on(next: { user in
                self.user = user
                let viewmodel = ProfileHeaderViewModel(imageService: self.imageService, user: user)
                self._profileHeaderViewModel.value = viewmodel
            })
            .map { _ in }
    }
}