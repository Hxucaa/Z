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
    private var backgroundUpdateWireframe: IBackgroundUpdateWireframe?
    private var detailWireframe: DetailWireframe?
    
    
    public init(window: UIWindow) {
        let rootWireframe = RootWireframe(inWindow: window)
        let rw: IRealmWritter = RealmWritter()
        let bs: IBusinessService = BusinessService()
        let rs: IRealmService = RealmService.sharedInstance
        let dm: IDataManager = DataManager(businessService: bs, realmService: rs, realmWritter: rw)
        
        configureDetailDependencies(rootWireframe, dataManager: dm, realmService: rs)
        configureNearbyDependencies(rootWireframe, dataManager: dm, realmService: rs)
        configureFeaturedListDependencies(rootWireframe, dataManager: dm, realmService: rs)
        configureBackgroundUpdateDependencies(dm)
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
    private func configureFeaturedListDependencies(rootWireframe: RootWireframe, dataManager dm: IDataManager, realmService rs: IRealmService) {
        
        // instantiate view model
        let featuredListVM: IFeaturedListViewModel = FeaturedListViewModel(datamanager: dm, realmService: rs)
        
        featuredListWireframe = FeaturedListWireframe(rootWireframe: rootWireframe, featuredListVM: featuredListVM, pushNearbyViewController: nearbyWireframe!.pushNearbyViewController, pushDetailViewController: detailWireframe!.pushDetailViewController)
    }
    
    /**
    Configure dependencies for Nearby Module.
    
    :param: rootWireframe The RootWireframe.
    */
    private func configureNearbyDependencies(rootWireframe: RootWireframe, dataManager dm: IDataManager, realmService rs: IRealmService) {
        
        // instantiate view model
        let nearbyVM: INearbyViewModel = NearbyViewModel(datamanager: dm, realmService: rs)
        
        nearbyWireframe = NearbyWireframe(rootWireframe: rootWireframe, nearbyViewModel: nearbyVM)
    }
    
    private func configureBackgroundUpdateDependencies(dm: IDataManager) {
        
        backgroundUpdateWireframe = BackgroundUpdateWireframe(dataManager: dm)
    }
    
    /**
    Configure dependencies for Detail Module.
    
    :param: rootWireframe The RootWireframe.
    */
    private func configureDetailDependencies(rootWireframe: RootWireframe, dataManager dm: IDataManager, realmService rs: IRealmService) {
        
        // instantiate view model
        let detailVM: IDetailViewModel = DetailViewModel(datamanager: dm, realmService: rs)
        
        detailWireframe = DetailWireframe(rootWireframe: rootWireframe, detailViewModel: detailVM)
        
    }
}
