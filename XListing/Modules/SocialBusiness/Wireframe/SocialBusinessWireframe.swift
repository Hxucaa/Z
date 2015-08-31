//
//  SocialBusinessWireframe.swift
//  XListing
//
//  Created by Lance Zhu on 2015-08-30.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation

private let SocialBusinessViewControllerIdentifier = "SocialBusinessViewController"
private let SocialBusinessStoryboardName = "SocialBusiness"

public final class SocialBusinessWireframe : BaseWireframe, ISocialBusinessWireframe {
    
    private let router: IRouter
    private let userService: IUserService
    private let participationService: IParticipationService
    private let geoLocationService: IGeoLocationService
    private let imageService: IImageService
    
    public required init(rootWireframe: IRootWireframe, router: IRouter, userService: IUserService, participationService: IParticipationService, geoLocationService: IGeoLocationService, imageService: IImageService) {
        
        self.router = router
        self.userService = userService
        self.participationService = participationService
        self.geoLocationService = geoLocationService
        self.imageService = imageService
        
        super.init(rootWireframe: rootWireframe)
    }
    
    /**
    Inject ViewModel to view controller.
    
    :returns: Properly configured DetailViewController.
    */
    private func injectViewModelToViewController(businessModel: Business) -> SocialBusinessViewController {
        // retrieve view controller from storyboard
        let viewController = getViewControllerFromStoryboard(SocialBusinessViewControllerIdentifier, storyboardName: SocialBusinessStoryboardName) as! SocialBusinessViewController
        let socialBusinessViewModel = SocialBusinessViewModel(router: router, userService: userService, participationService: participationService, geoLocationService: geoLocationService, imageService: imageService, businessModel: businessModel)
        viewController.bindToViewModel(socialBusinessViewModel)
        
        return viewController
    }
}

extension SocialBusinessWireframe : SocialBusinessRoute {
    public func pushWithData<T : Business>(business: T) {
        let injectedViewController = injectViewModelToViewController(business)
        rootWireframe.pushViewController(injectedViewController, animated: true)
    }
}