//
//  FeaturedListWireframe.swift
//  XListing
//
//  Created by Lance Zhu on 2015-03-23.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation

private let FeaturedListViewControllerIdentifier = "FeaturedListViewController"

public final class FeaturedListWireframe : BaseWireframe {
    
    private let navigator: INavigator
    private let businessService: IBusinessService
    private let userService: IUserService
    private let geoLocationService: IGeoLocationService
    private var featuredListViewController: FeaturedListViewController?
    
    public required init(rootWireframe: IRootWireframe, navigator: INavigator, businessService: IBusinessService, userService: IUserService, geoLocationService: IGeoLocationService) {
        self.navigator = navigator
        self.businessService = businessService
        self.userService = userService
        self.geoLocationService = geoLocationService
        
        super.init(rootWireframe: rootWireframe)
    }
    
    /**
        Inject ViewModel to view controller.
    
        :returns: Properly configured FeaturedListViewController.
    */
    private func initViewController() -> FeaturedListViewController {
        // retrieve view controller from storyboard
        let viewController = getViewControllerFromStoryboard(FeaturedListViewControllerIdentifier) as! FeaturedListViewController
        let viewmodel = FeaturedListViewModel(navigator: navigator, businessService: businessService, userService: userService, geoLocationService: geoLocationService)
        viewController.bindToViewModel(viewmodel)
        
        featuredListViewController = viewController
        return viewController
    }
}

extension FeaturedListWireframe : IFeaturedListWireframe {
    
    /**
    Show FeaturedList as root view controller.
    */
    public func showFeaturedListAsRootViewController() {
        
        let injectedViewController = initViewController()
        rootWireframe.showRootViewController(injectedViewController)
        
    }
}