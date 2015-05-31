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
        
        configureAccountDependencies(rootWireframe, navigator: navigator, userService: us)
        configureFeaturedListDependencies(rootWireframe, navigator: navigator, businessService: bs, userService: us, geoLocationService: gs)
        configureNearbyDependencies(rootWireframe, navigator: navigator, businessService: bs, geoLocationService: gs)
        configureDetailDependencies(rootWireframe, navigator: navigator, wantToGoService: wtg, geoLocationService: gs)
        configureProfileDependencies(rootWireframe, navigator: navigator, userService: us)
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
    private func configureFeaturedListDependencies(rootWireframe: IRootWireframe, navigator: INavigator, businessService bs: IBusinessService, userService us: IUserService, geoLocationService gs: IGeoLocationService) {
        
        featuredListWireframe = FeaturedListWireframe(rootWireframe: rootWireframe, navigator: navigator, businessService: bs, userService: us, geoLocationService: gs)
    }
    
    /**
    Configure dependencies for Nearby Module.
    
    :param: rootWireframe The RootWireframe.
    */
    private func configureNearbyDependencies(rootWireframe: IRootWireframe, navigator: INavigator, businessService bs: IBusinessService, geoLocationService gs: IGeoLocationService) {
        
        nearbyWireframe = NearbyWireframe(rootWireframe: rootWireframe, navigator: navigator, businessService: bs, geoLocationService: gs)
    }
    
    /**
    Configure dependencies for Detail Module.
    
    :param: rootWireframe The RootWireframe.
    */
    private func configureDetailDependencies(rootWireframe: IRootWireframe, navigator: INavigator, wantToGoService wtg: IWantToGoService, geoLocationService gs: IGeoLocationService) {
        
        detailWireframe = DetailWireframe(rootWireframe: rootWireframe, navigator: navigator, wantToGoService: wtg, geoLocationService: gs)
    }
    
    private func configureAccountDependencies(rootWireframe: IRootWireframe, navigator: INavigator, userService us: IUserService) {
        
        accountWireframe = AccountWireframe(rootWireframe: rootWireframe, navigator: navigator, userService: us)
    }

    private func configureProfileDependencies(rootWireframe: IRootWireframe, navigator: INavigator, userService us: IUserService) {

        profileWireframe = ProfileWireframe(rootWireframe: rootWireframe, navigator: navigator, userService: us)
    }
}
