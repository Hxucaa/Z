//
// Created by Lance on 15-05-06.
// Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import UIKit

private let ProfileViewControllerIdentifier = "ProfileViewController"
private let StoryboardName = "Profile"

public final class ProfileWireframe : IProfileWireframe {

    public var rootViewController: UIViewController {
        return initViewController()
    }

    private let businessService: IBusinessService
    private let userService: IUserService
    private let geoLocationService: IGeoLocationService
    private let userDefaultsService: IUserDefaultsService
    private let imageService: IImageService
    private let participationService: IParticipationService
    
    public required init(participationService: IParticipationService, businessService: IBusinessService, userService: IUserService, geoLocationService: IGeoLocationService, userDefaultsService: IUserDefaultsService, imageService: IImageService) {
        self.businessService = businessService
        self.userService = userService
        self.geoLocationService = geoLocationService
        self.userDefaultsService = userDefaultsService
        self.imageService = imageService
        self.participationService = participationService
    }
    
    private func initViewController() -> ProfileViewController {
        let viewController = UIStoryboard(name: StoryboardName, bundle: nil).instantiateViewControllerWithIdentifier(ProfileViewControllerIdentifier) as! ProfileViewController
        
        let viewmodel = ProfileViewModel(participationService: participationService, businessService: businessService, userService: userService, geoLocationService: geoLocationService, userDefaultsService: userDefaultsService, imageService: imageService)
        
        viewController.bindToViewModel(viewmodel)
        
        return viewController
    }
}

//extension ProfileWireframe : ProfileRoute {
//    public func push() {
//        let injectedViewController = initViewController()
////        rootWireframe.pushViewController(injectedViewController, animated: true)
//    }
//}