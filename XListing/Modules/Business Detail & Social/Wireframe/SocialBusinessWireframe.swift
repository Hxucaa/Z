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
    
    private let meService: IMeService
    private let participationService: IParticipationService
    private let geoLocationService: IGeoLocationService
    private let imageService: IImageService
    
    public weak var sharedNavigationController: UINavigationController?
    private weak var socialBusinessViewController: SocialBusinessViewController?
    
    public required init(meService: IMeService, participationService: IParticipationService, geoLocationService: IGeoLocationService, imageService: IImageService) {
        self.meService = meService
        self.participationService = participationService
        self.geoLocationService = geoLocationService
        self.imageService = imageService
    }
    
    /**
     Inject ViewModel to view controller.
     
     - parameter business: Business object.
    
     - returns: Properly configured DetailViewController.
     */
    private func injectViewModelToViewController(business: Business) -> SocialBusinessViewController {
        let viewController = SocialBusinessViewController()
        
        let socialBusinessViewModel = SocialBusinessViewModel(meService: meService, participationService: participationService, geoLocationService: geoLocationService, imageService: imageService, business: business)
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
        let viewController = PublicProfileViewController()
        
        let publicProfileViewModel = PublicProfileViewModel(meService: meService, imageService: imageService)
        publicProfileViewModel.navigator = self
        viewController.bindToViewModel(publicProfileViewModel)
        
        sharedNavigationController?.pushViewController(viewController, animated: animated)
    }
    
    public func pushBusinessDetail(business: Business, animated: Bool) {
        let viewController = BusinessDetailViewController()
        
        let businessDetailViewModel = BusinessDetailViewModel(meService: meService, participationService: participationService, geoLocationService: geoLocationService, imageService: imageService, business: business)
        viewController.bindToViewModel(businessDetailViewModel)
        
        sharedNavigationController?.delegate = socialBusinessViewController
        
        sharedNavigationController?.pushViewController(viewController, animated: animated)
        sharedNavigationController?.delegate = nil
    }
}

extension SocialBusinessWireframe : PublicProfileNavigator {
    public func presentFullScreenImage(imageURL: NSURL, animated: Bool, completion: CompletionHandler?) {
        
        let viewController = FullScreenImageViewController()
        let fullScreenImageViewModel = FullScreenImageViewModel(imageService: imageService)
        viewController.bindToViewModel(fullScreenImageViewModel)
        sharedNavigationController?.presentViewController(viewController, animated: true, completion: completion)
    }
    
}