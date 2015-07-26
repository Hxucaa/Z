//
// Created by Lance on 15-05-06.
// Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import UIKit

private let ProfileViewControllerIdentifier = "ProfileViewController"
private let StoryboardName = "Profile"

public final class ProfileWireframe : BaseWireframe, IProfileWireframe {
    
    private let router: IRouter
    private let businessService: IBusinessService
    private let userService: IUserService
    private let geoLocationService: IGeoLocationService
    private let userDefaultsService: IUserDefaultsService
    private let imageService: IImageService
    
    public required init(rootWireframe: IRootWireframe, router: IRouter, businessService: IBusinessService, userService: IUserService, geoLocationService: IGeoLocationService, userDefaultsService: IUserDefaultsService, imageService: IImageService) {
        self.router = router
        self.businessService = businessService
        self.userService = userService
        self.geoLocationService = geoLocationService
        self.userDefaultsService = userDefaultsService
        self.imageService = imageService
        
        super.init(rootWireframe: rootWireframe)
    }
    
    private func initViewController() -> ProfileViewController {
        let viewController = getViewControllerFromStoryboard(ProfileViewControllerIdentifier, storyboardName: StoryboardName) as! ProfileViewController
        
        let viewmodel = ProfileViewModel(router: router, businessService: businessService, userService: userService, geoLocationService: geoLocationService, userDefaultsService: userDefaultsService, imageService: imageService)
        
        viewController.bindToViewModel(viewmodel)
        
        return viewController
    }
}

extension ProfileWireframe : ProfileRoute {
    public func push() {
        let injectedViewController = initViewController()
        rootWireframe.pushViewController(injectedViewController, animated: true)
    }
}