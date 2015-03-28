//
//  FeaturedListWireframe.swift
//  XListing
//
//  Created by Lance Zhu on 2015-03-23.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation

let FeaturedListViewControllerIdentifier = "FeaturedListViewController"

public class FeaturedListWireframe : BaseWireframe {
    
    private let featuredListPresenter: IFeaturedListPresenter?
    private let rootWireframe: RootWireframe?
    private var featuredListViewController: FeaturedListViewController?
    
    public init(rootWireframe: RootWireframe, featuredListPresenter: IFeaturedListPresenter) {
        self.rootWireframe = rootWireframe
        self.featuredListPresenter = featuredListPresenter
    }
    
    /**
        Display FeaturedList to Window.
        
        :param: window The UIWindow.
    */
    public func presentFeaturedListInterfaceFromWindows(window: UIWindow) {
        
        let injectedViewController = injectPresenterToViewController()
        rootWireframe?.showRootViewController(injectedViewController, inWindow: window)
        
    }
    
    /**
        Inject presenter to view controller.
    
        :returns: Properly configured FeaturedListViewController.
    */
    private func injectPresenterToViewController() -> FeaturedListViewController {
        // retrieve view controller from storyboard
        let viewController = getViewControllerFromStoryboard(FeaturedListViewControllerIdentifier) as FeaturedListViewController
        viewController.featuredListPresenter = featuredListPresenter
        featuredListViewController = viewController
        return viewController
    }
}