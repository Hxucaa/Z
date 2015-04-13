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
    
    private var featuredListWireframe: IFeaturedListWireframe?
    private var nearbyWireframe: NearbyWireframe?
    
    /// singleton
    private let realmService: IRealmService = RealmService()
    
    public init(window: UIWindow) {
        let rootWireframe = RootWireframe(inWindow: window)
        configureNearbyDependencies(rootWireframe)
        configureFeaturedListDependencies(rootWireframe)
    }
    
    /**
        Install the root view controller to the window for display.
    
        :param: window The UIWindow that needs to have a root view installed.
    */
    public func installRootViewControllerIntoWindow() {
        featuredListWireframe?.showFeaturedListAsRootViewController()
    }
    
    /**
        Configure dependencies for FeaturedList Module.

        :param: rootWireframe The RootWireframe.
    */
    private func configureFeaturedListDependencies(rootWireframe: RootWireframe) {
        
        let businessService: IBusinessService = BusinessService()
        let realmWritter: IRealmWritter = RealmWritter()
        
        // instantiate data manager
        let dm: IDataManager = DataManager(businessService: businessService, realmService: realmService, realmWritter: realmWritter)
        
        // instantiate view model
        let featuredListVM: IFeaturedListViewModel = FeaturedListViewModel(datamanager: dm, realmService: realmService)
        
        featuredListWireframe = FeaturedListWireframe(rootWireframe: rootWireframe, featuredListVM: featuredListVM, pushNearbyViewController: nearbyWireframe!.pushNearbyViewController)
    }
    
    /**
    Configure dependencies for Nearby Module.
    
    :param: rootWireframe The RootWireframe.
    */
    private func configureNearbyDependencies(rootWireframe: RootWireframe) {
        
        let businessService: IBusinessService = BusinessService()
        let realmWritter: IRealmWritter = RealmWritter()
        
        // instantiate data manager
        let dm: IDataManager = DataManager(businessService: businessService, realmService: realmService, realmWritter: realmWritter)
        
        // instantiate view model
        let nearbyVM: INearbyViewModel = NearbyViewModel(datamanager: dm, realmService: realmService)
        
        nearbyWireframe = NearbyWireframe(rootWireframe: rootWireframe, nearbyViewModel: nearbyVM)
    }
}
