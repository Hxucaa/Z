//
// Created by Lance Zhu on 15-05-06.
// Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import UIKit

private let ProfileViewControllerIdentifier = "ProfileViewController"
private let StoryboardName = "Profile"

public protocol ProfileNavigationControllerDelegate : class {
    func pushSocialBusiness<T: Business>(business: T, animated: Bool)
    func presentProfileEdit<T: User>(user: T, animated: Bool, completion: CompletionHandler?)
}

public final class ProfileWireframe : IProfileWireframe {

    public var rootViewController: UIViewController {
        return initViewController()
    }

    public weak var navigationControllerDelegate: ProfileNavigationControllerDelegate!

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

        viewmodel.navigator = self
        
        viewController.bindToViewModel(viewmodel)
        
        return viewController
    }
}

extension ProfileWireframe : ProfileNavigator {
    public func pushSocialBusiness(business: Business, animated: Bool) {
        navigationControllerDelegate.pushSocialBusiness(business, animated: animated)
    }
    public func presentProfileEdit(user: User, animated: Bool, completion: CompletionHandler?) {
        navigationControllerDelegate.presentProfileEdit(user, animated: animated, completion: completion)
    }
}