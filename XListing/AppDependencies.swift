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
    private var nearbyWireframe: INearbyWireframe?
    private var backgroundUpdateWireframe: IBackgroundUpdateWireframe?
    private var detailWireframe: IDetailWireframe?
    private var accountWireframe: IAccountWireframe?
    
    
    public init(window: UIWindow) {
        let rootWireframe: IRootWireframe = RootWireframe(inWindow: window)
        let rw: IRealmWritter = RealmWritter()
        let us: IUserService = UserService()
        let bs: IBusinessService = BusinessService()
        let wtg: IWantToGoService = WantToGoService()
        let rs: IRealmService = RealmService.sharedInstance
        let dm: IDataManager = DataManager(businessService: bs, realmService: rs, realmWritter: rw)
        
        
        configureBackgroundUpdateDependencies(dm)
        configureFeaturedListDependencies(rootWireframe, dataManager: dm, realmService: rs)
        configureDetailDependencies(rootWireframe, dataManager: dm, realmService: rs, wantToGoService: wtg)
        configureNearbyDependencies(rootWireframe, dataManager: dm, realmService: rs)
        configureAccountDependencies(rootWireframe, userService: us)
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
    private func configureFeaturedListDependencies(rootWireframe: IRootWireframe, dataManager dm: IDataManager, realmService rs: IRealmService) {
        
        // instantiate view model
        let featuredListVM: IFeaturedListViewModel = FeaturedListViewModel(datamanager: dm, realmService: rs)
        
        featuredListWireframe = FeaturedListWireframe(rootWireframe: rootWireframe, featuredListVM: featuredListVM)
        
    }
    
    /**
    Configure dependencies for Nearby Module.
    
    :param: rootWireframe The RootWireframe.
    */
    private func configureNearbyDependencies(rootWireframe: IRootWireframe, dataManager dm: IDataManager, realmService rs: IRealmService) {
        
        // instantiate view model
        let nearbyVM: INearbyViewModel = NearbyViewModel(datamanager: dm, realmService: rs)
        
        nearbyWireframe = NearbyWireframe(rootWireframe: rootWireframe, nearbyViewModel: nearbyVM)
        
        featuredListWireframe?.nearbyInterfaceDelegate = nearbyWireframe as? FeaturedListInterfaceToNearbyInterfaceDelegate
    }
    
    private func configureBackgroundUpdateDependencies(dm: IDataManager) {
        
        backgroundUpdateWireframe = BackgroundUpdateWireframe(dataManager: dm)
    }
    
    /**
    Configure dependencies for Detail Module.
    
    :param: rootWireframe The RootWireframe.
    */
    private func configureDetailDependencies(rootWireframe: IRootWireframe, dataManager dm: IDataManager, realmService rs: IRealmService, wantToGoService wtg: IWantToGoService) {
        
        // instantiate view model
        let detailVM: IDetailViewModel = DetailViewModel(datamanager: dm, realmService: rs, wantToGoService: wtg)
        
        detailWireframe = DetailWireframe(rootWireframe: rootWireframe, detailViewModel: detailVM)
        
        featuredListWireframe?.detailInterfaceDelegate = detailWireframe as? FeaturedListInterfaceToDetailInterfaceDelegate
    }
    
    private func configureAccountDependencies(rootWireframe: IRootWireframe, userService us: IUserService) {
        let accountVM: IAccountViewModel = AccountViewModel(userService: us)
        
        accountWireframe = AccountWireframe(rootWireframe: rootWireframe, accountVM: accountVM)
    }
}
