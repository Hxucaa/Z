//
//  FeaturedListWireframe.swift
//  XListing
//
//  Created by Lance Zhu on 2015-03-23.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation

let FeaturedListViewControllerIdentifier = "FeaturedListViewController"

class FeaturedListWireframe : NSObject {
    
    var featuredListPresenter: FeaturedListPresenter?
    var rootWireframe: RootWireframe?
    var featuredListViewController: FeaturedListViewController?
    
    func presentFeaturedListInterfaceFromWindows(window: UIWindow) {
        let viewController = featuredListViewControllerFromStoryboard()
        viewController.featuredListPresenter = featuredListPresenter
        featuredListViewController = viewController
        rootWireframe?.showRootViewController(viewController, inWindow: window)
        
    }
    
    private func featuredListViewControllerFromStoryboard() -> FeaturedListViewController {
        let storyboard = mainStoryboard()
        let viewController = storyboard.instantiateViewControllerWithIdentifier(FeaturedListViewControllerIdentifier) as FeaturedListViewController
        return viewController
    }
    
    private func mainStoryboard() -> UIStoryboard {
        let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        return storyboard
    }
}