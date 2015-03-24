//
//  AppDependencies.swift
//  XListing
//
//  Created by Lance Zhu on 2015-03-23.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation

class AppDependencies {
    
    var featuredListWireframe = FeaturedListWireframe()
    
    init() {
        configureDependencies()
    }
    
    func installRootViewControllerIntoWindow(window: UIWindow) {
        featuredListWireframe.presentFeaturedListInterfaceFromWindows(window)
    }
    
    func configureDependencies() {
        let rootWireframe = RootWireframe()
        
        let locationDataManager = LocationManager()
        let featuredListDataManager = ListManager()
        let featuredListInteractor = FeaturedListInteractor(featuredListDataManager: featuredListDataManager, locationDataManager: locationDataManager)
        let featuredListPresenter = FeaturedListPresenter(featuredListInteractor: featuredListInteractor)
        
        featuredListWireframe.featuredListPresenter = featuredListPresenter
        featuredListWireframe.rootWireframe = rootWireframe
    }
}
