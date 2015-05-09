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
    private var detailWireframe: IDetailWireframe?
    private var accountWireframe: IAccountWireframe?
    private var profileWireframe: IProfileWireframe?
    
    public init(window: UIWindow) {
        let rootWireframe: IRootWireframe = RootWireframe(inWindow: window)
        let gs: IGeoLocationService = GeoLocationService()
        let us: IUserService = UserService()
        let bs: IBusinessService = BusinessService()
        let wtg: IWantToGoService = WantToGoService()
        
        
        configureFeaturedListDependencies(rootWireframe, businessService: bs, geoLocationService: gs)
        configureNearbyDependencies(rootWireframe, businessService: bs, geoLocationService: gs)
        configureDetailDependencies(rootWireframe, wantToGoService: wtg, businessService: bs, geoLocationService: gs)
        configureProfileDependencies(rootWireframe, wantToGoService: wtg)
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
    private func configureFeaturedListDependencies(rootWireframe: IRootWireframe, businessService bs: IBusinessService, geoLocationService gs: IGeoLocationService) {
        
        // instantiate view model
        let featuredListVM: IFeaturedListViewModel = FeaturedListViewModel(businessService: bs, geoLocationService: gs)
        
        featuredListWireframe = FeaturedListWireframe(rootWireframe: rootWireframe, featuredListVM: featuredListVM)
    }
    
    /**
    Configure dependencies for Nearby Module.
    
    :param: rootWireframe The RootWireframe.
    */
    private func configureNearbyDependencies(rootWireframe: IRootWireframe, businessService bs: IBusinessService, geoLocationService gs: IGeoLocationService) {
        
        // instantiate view model
        let nearbyVM: INearbyViewModel = NearbyViewModel(businessService: bs, geoLocationService: gs)
        
        nearbyWireframe = NearbyWireframe(rootWireframe: rootWireframe, nearbyViewModel: nearbyVM)
    }
    
    /**
    Configure dependencies for Detail Module.
    
    :param: rootWireframe The RootWireframe.
    */
    private func configureDetailDependencies(rootWireframe: IRootWireframe, wantToGoService wtg: IWantToGoService, businessService bs: IBusinessService, geoLocationService gs: IGeoLocationService) {
        
        // instantiate view model
        let detailVM: IDetailViewModel = DetailViewModel(wantToGoService: wtg, businessService: bs, geoLocationService: gs)
        
        detailWireframe = DetailWireframe(rootWireframe: rootWireframe, detailViewModel: detailVM)
    }
    
    private func configureAccountDependencies(rootWireframe: IRootWireframe, userService us: IUserService) {
        let accountVM: IAccountViewModel = AccountViewModel(userService: us)
        
        accountWireframe = AccountWireframe(rootWireframe: rootWireframe, accountVM: accountVM)
    }

    private func configureProfileDependencies(rootWireframe: IRootWireframe, wantToGoService wtg: IWantToGoService) {
        let profileVM: IProfileViewModel = ProfileViewModel(wantToGoService: wtg)

        profileWireframe = ProfileWireframe(rootWireframe: rootWireframe, profileViewModel: profileVM)
    }
}
