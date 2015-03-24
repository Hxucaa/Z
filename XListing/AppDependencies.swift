//
//  AppDependencies.swift
//  XListing
//
//  Created by Lance Zhu on 2015-03-23.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation

class AppDependencies {
    
    private var featuredListWireframe: FeaturedListWireframe?
    
    init() {
        let rootWireframe = RootWireframe()
        
        configureFeaturedListDependencies(rootWireframe)
    }
    
    func installRootViewControllerIntoWindow(window: UIWindow) {
        featuredListWireframe?.presentFeaturedListInterfaceFromWindows(window)
    }
    
    private func configureFeaturedListDependencies(rootWireframe: RootWireframe) {
        
        // create data manager first
        let locationDataManager = LocationDataManager()
        let featuredListDataManager = FeaturedListDataManager()
        
        // instantiate interactor next
        let featuredListInteractor = FeaturedListInteractor(featuredListDataManager: featuredListDataManager, locationDataManager: locationDataManager)
        
        // instantiate presenter next
        let featuredListPresenter = FeaturedListPresenter(featuredListInteractor: featuredListInteractor)
        
        featuredListWireframe = FeaturedListWireframe(rootWireframe: rootWireframe, featuredListPresenter: featuredListPresenter)
    }
}
