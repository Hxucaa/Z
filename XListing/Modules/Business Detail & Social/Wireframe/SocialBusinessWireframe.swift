//
//  SocialBusinessWireframe.swift
//  XListing
//
//  Created by Lance Zhu on 2015-08-30.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import UIKit

private let UserProfileViewControllerIdentifier = "UserProfileViewController"
private let UserProfileStoryboardName = "UserProfile"

public final class SocialBusinessWireframe : ISocialBusinessWireframe {
    
    private let userService: IUserService
    private let participationService: IParticipationService
    private let geoLocationService: IGeoLocationService
    private let imageService: IImageService
    
    public weak var sharedNavigationController: UINavigationController?
    private weak var socialBusinessViewController: SocialBusinessViewController?
    
    public required init(userService: IUserService, participationService: IParticipationService, geoLocationService: IGeoLocationService, imageService: IImageService) {
        self.userService = userService
        self.participationService = participationService
        self.geoLocationService = geoLocationService
        self.imageService = imageService
    }
    
    /**
    Inject ViewModel to view controller.
    
    :returns: Properly configured DetailViewController.
    */
    private func injectViewModelToViewController(businessModel: Business) -> SocialBusinessViewController {
        let viewController = SocialBusinessViewController()
        
        let socialBusinessViewModel = SocialBusinessViewModel(userService: userService, participationService: participationService, geoLocationService: geoLocationService, imageService: imageService, businessModel: businessModel)
        socialBusinessViewModel.navigator = self
        viewController.bindToViewModel(socialBusinessViewModel)
        
        socialBusinessViewController = viewController
        
        return viewController
    }
    
    public func viewController(business: Business) -> SocialBusinessViewController {
        return injectViewModelToViewController(business)
    }
}

extension SocialBusinessWireframe : SocialBusinessNavigator {
    public func pushUserProfile(user: User, animated: Bool) {
        let viewController = UIStoryboard(name: UserProfileStoryboardName, bundle: nil).instantiateViewControllerWithIdentifier(UserProfileViewControllerIdentifier) as! UserProfileViewController
        
        let userProfileViewModel = UserProfileViewModel()
        viewController.bindToViewModel(userProfileViewModel)
        
        sharedNavigationController?.pushViewController(viewController, animated: animated)
    }
    
    public func pushBusinessDetail(business: Business, animated: Bool) {
        let viewController = BusinessDetailViewController()
        
        let businessDetailViewModel = BusinessDetailViewModel(userService: userService, participationService: participationService, geoLocationService: geoLocationService, imageService: imageService, business: business)
        viewController.bindToViewModel(businessDetailViewModel)
        
        sharedNavigationController?.delegate = socialBusinessViewController
        
        sharedNavigationController?.pushViewController(viewController, animated: animated)
        sharedNavigationController?.delegate = nil
    }
}