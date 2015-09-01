//
//  AppDependencies.swift
//  XListing
//
//  Created by Lance Zhu on 2015-03-23.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import ReactiveCocoa

/**
    Dependency injector.
*/
public final class AppDependencies {

    private let featuredTabItem: TabItem<FeaturedTabContent>
    private let nearbyTabItem: TabItem<NearbyTabContent>
    private let profileTabItem: TabItem<ProfileTabContent>
    private let rootTabBarWireframe: IRootTabBarWireframe

    private let featuredListWireframe: IFeaturedListWireframe
    private let nearbyWireframe: INearbyWireframe
    private let detailWireframe: IDetailWireframe
    private let accountWireframe: IAccountWireframe
    private let profileWireframe: IProfileWireframe
    private let wantToGoListWireframe: IWantToGoListWireframe
    private let profileEditWireframe: IProfileEditWireframe
    private let socialBusinessWireframe: ISocialBusinessWireframe

    private let gs: IGeoLocationService = GeoLocationService()
    private let bs: IBusinessService = BusinessService()
    private let ps: IParticipationService = ParticipationService()
    private let ks: IKeychainService = KeychainService()
    private let imageService: IImageService = ImageService()
    private let us: IUserService = UserService()
    private let uds: IUserDefaultsService = UserDefaultsService()

    public init(window: UIWindow) {
        // init HUD
        HUD.sharedInstance
        
        detailWireframe = DetailWireframe(userService: us, participationService: ps, geoLocationService: gs, imageService: imageService)
        accountWireframe = AccountWireframe(userService: us, userDefaultsService: uds)
        wantToGoListWireframe = WantToGoListWireframe(userService: us, participationService: ps, imageService: imageService)
        
        featuredListWireframe = FeaturedListWireframe(businessService: bs, userService: us, geoLocationService: gs, userDefaultsService: uds, imageService: imageService)
        nearbyWireframe = NearbyWireframe(businessService: bs, geoLocationService: gs, imageService: imageService)
        profileWireframe = ProfileWireframe(participationService: ps, businessService: bs, userService: us, geoLocationService: gs, userDefaultsService: uds, imageService: imageService)
        profileEditWireframe = ProfileEditWireframe(userService: us)
        socialBusinessWireframe = SocialBusinessWireframe(userService: us, participationService: ps, geoLocationService: gs, imageService: imageService)

        featuredTabItem = TabItem(tabContent: FeaturedTabContent(featuredListWireframe: featuredListWireframe, socialBusinessWireframe: socialBusinessWireframe))
        nearbyTabItem = TabItem(tabContent: NearbyTabContent(nearbyWireframe: nearbyWireframe, socialBusinessWireframe: socialBusinessWireframe))
        profileTabItem = TabItem(tabContent: ProfileTabContent(profileWireframe: profileWireframe, profileEditWireframe: profileEditWireframe))
        
        rootTabBarWireframe = RootTabBarWireframe(inWindow: window, featuredListTabItem: featuredTabItem, nearbyTabItem: nearbyTabItem, profileTabItem: profileTabItem)
    }

    /**
        Install the root view controller to the window for display.
    
        :param: window The UIWindow that needs to have a root view installed.
    */
    public func installRootViewControllerIntoWindow() {
//        if !userDefaultsService.accountModuleSkipped && !userService.isLoggedInAlready() {
//            router.pushAccount()
//        }
//        else {
//            router.pushFeatured()
//        }
    }
}
