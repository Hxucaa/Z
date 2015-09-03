//
//  FeaturedListWireframe.swift
//  XListing
//
//  Created by Lance Zhu on 2015-03-23.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import UIKit
import ReactiveCocoa

private let FeaturedListViewControllerIdentifier = "FeaturedListViewController"
private let StoryboardName = "FeaturedList"

public protocol FeaturedListNavigationControllerDelegate : class {
    func pushSocialBusiness<T : Business>(business: T)
}

public final class FeaturedListWireframe : IFeaturedListWireframe {
    
    public var rootViewController: UIViewController {
        return initViewController()
    }
    
    public weak var navigationControllerDelegate: FeaturedListNavigationControllerDelegate!
    
    private let businessService: IBusinessService
    private let userService: IUserService
    private let geoLocationService: IGeoLocationService
    private let userDefaultsService: IUserDefaultsService
    private let imageService: IImageService
    private let participationService: IParticipationService
    
    public required init(businessService: IBusinessService, userService: IUserService, geoLocationService: IGeoLocationService, userDefaultsService: IUserDefaultsService, imageService: IImageService, participationService: IParticipationService) {
        self.businessService = businessService
        self.userService = userService
        self.geoLocationService = geoLocationService
        self.userDefaultsService = userDefaultsService
        self.imageService = imageService
        self.participationService = participationService
    }
    
    /**
        Inject ViewModel to view controller.
    
        :returns: Properly configured FeaturedListViewController.
    */
    private func initViewController() -> FeaturedListViewController {
        // retrieve view controller from storyboard
        let viewController = UIStoryboard(name: StoryboardName, bundle: nil).instantiateViewControllerWithIdentifier(FeaturedListViewControllerIdentifier) as! FeaturedListViewController
        let viewmodel = FeaturedListViewModel(businessService: businessService, userService: userService, geoLocationService: geoLocationService, userDefaultsService: userDefaultsService, imageService: imageService, participationService: participationService)

        viewmodel.navigator = self

        viewController.bindToViewModel(viewmodel)
        
        return viewController
    }
}

extension FeaturedListWireframe : FeaturedListNavigator {
    
    public func pushSocialBusiness(business: Business) {
        navigationControllerDelegate.pushSocialBusiness(business)
    }
}