//
//  FeaturedListWireframe.swift
//  XListing
//
//  Created by Lance Zhu on 2015-03-23.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation

let FeaturedListViewControllerIdentifier = "FeaturedListViewController"

class FeaturedListWireframe {
    
    private var featuredListPresenter: IFeaturedListPresenter?
    private var rootWireframe: RootWireframe?
    private var featuredListViewController: FeaturedListViewController?
    
    init(rootWireframe: RootWireframe, featuredListPresenter: IFeaturedListPresenter) {
        self.rootWireframe = rootWireframe
        self.featuredListPresenter = featuredListPresenter
    }
    
    func presentFeaturedListInterfaceFromWindows(window: UIWindow) {
        let viewController = featuredListViewControllerFromStoryboard()
        viewController.featuredListPresenter = featuredListPresenter
        featuredListViewController = viewController
        rootWireframe?.showRootViewController(viewController, inWindow: window)
        
    }
    
    ///
    /// @abstract Get FeaturedListViewController from the storyboard.
    ///
    private func featuredListViewControllerFromStoryboard() -> FeaturedListViewController {
        let storyboard = mainStoryboard()
        let viewController = storyboard.instantiateViewControllerWithIdentifier(FeaturedListViewControllerIdentifier) as FeaturedListViewController
        return viewController
    }
    
    ///
    /// @abstract Get storyboard
    ///
    private func mainStoryboard() -> UIStoryboard {
        let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        return storyboard
    }
}