//
//  AppDependencies.swift
//  XListing
//
//  Created by Lance Zhu on 2015-03-23.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation

/**
    Dependency injector.
*/
public class AppDependencies {
    
    private var featuredListWireframe: FeaturedListWireframe?
    
    public init() {
        let rootWireframe = RootWireframe()
        
        configureFeaturedListDependencies(rootWireframe)
    }
    
    /**
        Install the root view controller to the window for display.
    
        :param: window The UIWindow that needs to have a root view installed.
    */
    public func installRootViewControllerIntoWindow(window: UIWindow) {
        featuredListWireframe?.presentFeaturedListInterfaceFromWindows(window)
    }
    
    /**
        Configure dependencies for FeaturedList Module

        :param: rootWireframe The RootWireframe
    */
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
