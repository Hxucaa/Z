//
//  FeaturedListWireframe.swift
//  XListing
//
//  Created by Lance Zhu on 2015-03-23.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation

let FeaturedListViewControllerIdentifier = "FeaturedListViewController"

class FeaturedListWireframe : BaseWireframe {
    
    private var featuredListPresenter: IFeaturedListPresenter?
    private var rootWireframe: RootWireframe?
    private var featuredListViewController: FeaturedListViewController?
    
    init(rootWireframe: RootWireframe, featuredListPresenter: IFeaturedListPresenter) {
        self.rootWireframe = rootWireframe
        self.featuredListPresenter = featuredListPresenter
    }
    
    /**
        Display FeaturedList to Window.
        
        :param: window The UIWindow.
    */
    func presentFeaturedListInterfaceFromWindows(window: UIWindow) {
        
        let injectedViewController = injectPresenterToViewController()
        rootWireframe?.showRootViewController(injectedViewController, inWindow: window)
        
    }
    
    /**
        Inject presenter to view controller.
    
        :returns: Properly configured FeaturedListViewController.
    */
    private func injectPresenterToViewController() -> FeaturedListViewController {
        // retrieve view controller from storyboard
        let viewController = featuredListViewControllerFromStoryboard()
        viewController.featuredListPresenter = featuredListPresenter
        featuredListViewController = viewController
        return viewController
    }
    
    /**
        Get FeaturedListViewController from the storyboard.
        
        :returns: A FeaturedListViewController
    */
    private func featuredListViewControllerFromStoryboard() -> FeaturedListViewController {
        let storyboard = mainStoryboard()
        let viewController = storyboard.instantiateViewControllerWithIdentifier(FeaturedListViewControllerIdentifier) as FeaturedListViewController
        return viewController
    }
    
}