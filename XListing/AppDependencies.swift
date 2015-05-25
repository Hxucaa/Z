//
//  AppDependencies.swift
//  XListing
//
//  Created by Lance Zhu on 2015-03-23.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import UIKit

/**
    Dependency injector.
*/
public class AppDependencies {
    
    
    private var featuredListWireframe: IFeaturedListWireframe?
    private var nearbyWireframe: INearbyWireframe?
    private var detailWireframe: IDetailWireframe?
    private var accountWireframe: IAccountWireframe?
    private var profileWireframe: IProfileWireframe?
    
    public init(window: UIWindow) {
        let navigator: INavigator = Navigator()
        let rootWireframe: IRootWireframe = RootWireframe(inWindow: window)
        let gs: IGeoLocationService = GeoLocationService()
        let us: IUserService = UserService()
        let bs: IBusinessService = BusinessService()
        let wtg: IWantToGoService = WantToGoService()
        let ks: IKeychainService = KeychainService()
        
        
<<<<<<< HEAD
        configureFeaturedListDependencies(rootWireframe, businessService: bs, geoLocationService: gs)
        configureNearbyDependencies(rootWireframe, businessService: bs, geoLocationService: gs)
        configureDetailDependencies(rootWireframe, wantToGoService: wtg, geoLocationService: gs)
        configureProfileDependencies(rootWireframe, wantToGoService: wtg)
        configureAccountDependencies(rootWireframe, userService: us, keychainService: ks)
=======
        configureFeaturedListDependencies(rootWireframe, navigator: navigator, businessService: bs, geoLocationService: gs)
        configureNearbyDependencies(rootWireframe, navigator: navigator, businessService: bs, geoLocationService: gs)
        configureDetailDependencies(rootWireframe, navigator: navigator, wantToGoService: wtg, geoLocationService: gs)
        configureProfileDependencies(rootWireframe, navigator: navigator, wantToGoService: wtg)
        configureAccountDependencies(rootWireframe, navigator: navigator, userService: us)
>>>>>>> 0de4cdeb6f6bfe2727630d70fc40f24421a73b74
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
    private func configureFeaturedListDependencies(rootWireframe: IRootWireframe, navigator: INavigator, businessService bs: IBusinessService, geoLocationService gs: IGeoLocationService) {
        
        // instantiate view model
        let featuredListVM: IFeaturedListViewModel = FeaturedListViewModel(navigator: navigator, businessService: bs, geoLocationService: gs)
        
        featuredListWireframe = FeaturedListWireframe(rootWireframe: rootWireframe, featuredListVM: featuredListVM)
    }
    
    /**
    Configure dependencies for Nearby Module.
    
    :param: rootWireframe The RootWireframe.
    */
    private func configureNearbyDependencies(rootWireframe: IRootWireframe, navigator: INavigator, businessService bs: IBusinessService, geoLocationService gs: IGeoLocationService) {
        
        // instantiate view model
        let nearbyVM: INearbyViewModel = NearbyViewModel(navigator: navigator, businessService: bs, geoLocationService: gs)
        
        nearbyWireframe = NearbyWireframe(rootWireframe: rootWireframe, navigator: navigator, nearbyViewModel: nearbyVM)
    }
    
    /**
    Configure dependencies for Detail Module.
    
    :param: rootWireframe The RootWireframe.
    */
    private func configureDetailDependencies(rootWireframe: IRootWireframe, navigator: INavigator, wantToGoService wtg: IWantToGoService, geoLocationService gs: IGeoLocationService) {
        
        // instantiate view model
        let detailVM: IDetailViewModel = DetailViewModel(navigator: navigator, wantToGoService: wtg, geoLocationService: gs)
        
        detailWireframe = DetailWireframe(rootWireframe: rootWireframe, navigator: navigator, detailViewModel: detailVM)
    }
    
    private func configureAccountDependencies(rootWireframe: IRootWireframe, userService us: IUserService, keychainService ks: IKeychainService) {
        let accountVM: IAccountViewModel = AccountViewModel(userService: us, keychainService: ks)

        accountWireframe = AccountWirefrßame(rootWireframe: rootWireframe, navigator: navigator, accountVM: accountVM)
    }

    private func configureProfileDependencies(rootWireframe: IRootWireframe, navigator: INavigator, wantToGoService wtg: IWantToGoService) {
        let profileVM: IProfileViewModel = ProfileViewModel(wantToGoService: wtg)

        profileWireframe = ProfileWireframe(rootWireframe: rootWireframe, navigator: navigator, profileViewModel: profileVM)
    }
}
