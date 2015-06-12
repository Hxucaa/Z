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
        let router: IRouter = Router()
        let rootWireframe: IRootWireframe = RootWireframe(inWindow: window)
        let gs: IGeoLocationService = GeoLocationService()
        let us: IUserService = UserService()
        let bs: IBusinessService = BusinessService()
        let wtg: IWantToGoService = WantToGoService()
        let ks: IKeychainService = KeychainService()
        
        configureAccountDependencies(rootWireframe, router: router, userService: us)
        configureFeaturedListDependencies(rootWireframe, router: router, businessService: bs, userService: us, geoLocationService: gs)
        configureNearbyDependencies(rootWireframe, router: router, businessService: bs, geoLocationService: gs)
        configureDetailDependencies(rootWireframe, router: router, wantToGoService: wtg, geoLocationService: gs)
        configureProfileDependencies(rootWireframe, router: router, userService: us)
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
    private func configureFeaturedListDependencies(rootWireframe: IRootWireframe, router: IRouter, businessService bs: IBusinessService, userService us: IUserService, geoLocationService gs: IGeoLocationService) {
        
        featuredListWireframe = FeaturedListWireframe(rootWireframe: rootWireframe, router: router, businessService: bs, userService: us, geoLocationService: gs)
    }
    
    /**
    Configure dependencies for Nearby Module.
    
    :param: rootWireframe The RootWireframe.
    */
    private func configureNearbyDependencies(rootWireframe: IRootWireframe, router: IRouter, businessService bs: IBusinessService, geoLocationService gs: IGeoLocationService) {
        
        nearbyWireframe = NearbyWireframe(rootWireframe: rootWireframe, router: router, businessService: bs, geoLocationService: gs)
    }
    
    /**
    Configure dependencies for Detail Module.
    
    :param: rootWireframe The RootWireframe.
    */
    private func configureDetailDependencies(rootWireframe: IRootWireframe, router: IRouter, wantToGoService wtg: IWantToGoService, geoLocationService gs: IGeoLocationService) {
        
        detailWireframe = DetailWireframe(rootWireframe: rootWireframe, router: router, wantToGoService: wtg, geoLocationService: gs)
    }
    
    private func configureAccountDependencies(rootWireframe: IRootWireframe, router: IRouter, userService us: IUserService) {
        
        accountWireframe = AccountWireframe(rootWireframe: rootWireframe, router: router, userService: us)
    }

    private func configureProfileDependencies(rootWireframe: IRootWireframe, router: IRouter, userService us: IUserService) {

        profileWireframe = ProfileWireframe(rootWireframe: rootWireframe, router: router, userService: us)
    }
}
