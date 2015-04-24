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
    
    public weak var nearbyInterfaceDelegate: FeaturedListInterfaceToNearbyInterfaceDelegate?
    public weak var detailInterfaceDelegate: FeaturedListInterfaceToDetailInterfaceDelegate?
    
    public init(rootWireframe: RootWireframe, featuredListVM: IFeaturedListViewModel) {
        self.rootWireframe = rootWireframe
        self.featuredListVM = featuredListVM
    }
    
    /**
        Inject ViewModel to view controller.
    
        :returns: Properly configured FeaturedListViewController.
    */
    private func initViewController() -> FeaturedListViewController {
        // retrieve view controller from storyboard
        let viewController = getViewControllerFromStoryboard(FeaturedListViewControllerIdentifier) as! FeaturedListViewController
        viewController.featuredListVM = featuredListVM
        viewController.navigationDelegate = self
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

extension FeaturedListWireframe : FeaturedListViewControllerNavigationDelegate {
    public func pushNearby() {
        nearbyInterfaceDelegate?.pushInterface()
    }
    
    public func pushDetail(businessViewModel: BusinessViewModel) {
        detailInterfaceDelegate?.pushInterface(businessViewModel)
    }
}