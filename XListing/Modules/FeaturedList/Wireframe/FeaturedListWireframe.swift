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
    
    public init(rootWireframe: RootWireframe, featuredListVM: IFeaturedListViewModel) {
        self.rootWireframe = rootWireframe
        self.featuredListVM = featuredListVM
    }
    
    /**
        Display FeaturedList to Window.
        
        :param: window The UIWindow.
    */
    public func presentFeaturedListInterfaceFromWindows(window: UIWindow) {
        
        let injectedViewController = injectViewModelToViewController()
        rootWireframe.showRootViewController(injectedViewController, inWindow: window)
        
    }
    
    /**
        Inject ViewModel to view controller.
    
        :returns: Properly configured FeaturedListViewController.
    */
    private func injectViewModelToViewController() -> FeaturedListViewController {
        // retrieve view controller from storyboard
        let viewController = getViewControllerFromStoryboard(FeaturedListViewControllerIdentifier) as! FeaturedListViewController
        viewController.featuredListVM = featuredListVM
        featuredListViewController = viewController
        return viewController
    }
}