//
//  FeaturedListWireframe.swift
//  XListing
//
//  Created by Lance Zhu on 2015-03-23.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation

private let FeaturedListViewControllerIdentifier = "FeaturedListViewController"

public class FeaturedListWireframe : BaseWireframe {
    
    private let featuredListVM: IFeaturedListViewModel
    private let rootWireframe: RootWireframe
    private var featuredListViewController: FeaturedListViewController?
    private let pushNearbyViewController: () -> Void
    
    public init(rootWireframe: RootWireframe, featuredListVM: IFeaturedListViewModel, pushNearbyViewController: () -> Void) {
        self.rootWireframe = rootWireframe
        self.featuredListVM = featuredListVM
        self.pushNearbyViewController = pushNearbyViewController
    }
    
    /**
        Inject ViewModel to view controller.
    
        :returns: Properly configured FeaturedListViewController.
    */
    private func injectViewModelToViewController() -> FeaturedListViewController {
        // retrieve view controller from storyboard
        let viewController = getViewControllerFromStoryboard(FeaturedListViewControllerIdentifier) as! FeaturedListViewController
        viewController.featuredListVM = featuredListVM
        viewController.pushNearbyViewController = pushNearbyViewController
        featuredListViewController = viewController
        return viewController
    }
}

extension FeaturedListWireframe : IFeaturedListWireframe {
    
    /**
    Show FeaturedList as root view controller.
    */
    public func showFeaturedListAsRootViewController() {
        
        let injectedViewController = injectViewModelToViewController()
        rootWireframe.showRootViewController(injectedViewController)
        
    }
}