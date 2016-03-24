//
//  AppDependencies.swift
//  XListing
//
//  Created by Lance Zhu on 2015-03-23.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

// swiftlint:disable variable_name_min_length

import Foundation
import UIKit

/**
    Dependency injector.
*/
public final class AppDependencies {

    private let featuredTabItem: TabItem<FeaturedTabContent>
//    private let nearbyTabItem: TabItem<NearbyTabContent>
    private let profileTabItem: TabItem<ProfileTabContent>
    
    private var rootTabBarWireframe: IRootTabBarWireframe?

    private let featuredListWireframe: IFeaturedListWireframe
//    private let nearbyWireframe: INearbyWireframe
    private let accountWireframe: IAccountWireframe
    private let profileWireframe: IProfileWireframe
    private let profileEditWireframe: IProfileEditWireframe
    private let socialBusinessWireframe: ISocialBusinessWireframe
    private let fullScreenImageWireframe: IFullScreenImageWireframe

    private let gs: IGeoLocationService = GeoLocationService()
    private let bs: IBusinessService = BusinessService()
    private let ps: IParticipationService = ParticipationService()
    private let ks: IKeychainService = KeychainService()
    private let imageService: IImageService = ImageService()
    private let us: IUserService = UserService()
    private let uds: IUserDefaultsService = UserDefaultsService()
    private let ms: IMeService = MeService()

    public init(window: UIWindow) {
        // init HUD
        HUD.sharedInstance
        
        featuredListWireframe = FeaturedListWireframe(businessService: bs, userService: us, geoLocationService: gs, userDefaultsService: uds, imageService: imageService, participationService: ps)
//        nearbyWireframe = NearbyWireframe(businessService: bs, geoLocationService: gs, imageService: imageService)
        profileWireframe = ProfileWireframe(participationService: ps, businessService: bs, meService: ms, geoLocationService: gs, userDefaultsService: uds, imageService: imageService)
        profileEditWireframe = ProfileEditWireframe(meService: ms, imageService: imageService)
        socialBusinessWireframe = SocialBusinessWireframe(meService: ms, participationService: ps, geoLocationService: gs, imageService: imageService)
        accountWireframe = AccountWireframe(meService: ms, userDefaultsService: uds)
        fullScreenImageWireframe = FullScreenImageWireframe(imageService: imageService)

        featuredTabItem = TabItem(tabContent: FeaturedTabContent(featuredListWireframe: featuredListWireframe, socialBusinessWireframe: socialBusinessWireframe))
//        nearbyTabItem = TabItem(tabContent: NearbyTabContent(nearbyWireframe: nearbyWireframe, socialBusinessWireframe: socialBusinessWireframe))
        profileTabItem = TabItem(tabContent: ProfileTabContent(profileWireframe: profileWireframe, socialBusinessWireframe: socialBusinessWireframe, profileEditWireframe: profileEditWireframe, fullScreenImageWireframe: fullScreenImageWireframe))
        
//        rootTabBarWireframe = RootTabBarWireframe(inWindow: window, meService: ms, accountWireframe: accountWireframe, featuredListTabItem: featuredTabItem, nearbyTabItem: nearbyTabItem, profileTabItem: profileTabItem)
        rootTabBarWireframe = RootTabBarWireframe(inWindow: window, meService: ms, accountWireframe: accountWireframe, featuredListTabItem: featuredTabItem, profileTabItem: profileTabItem)
        
        if !uds.accountModuleSkipped && !ms.isLoggedInAlready() {
            window.rootViewController = accountWireframe.rootViewController
        }
        else {
            startTabBarApplication(window)
        }
        window.makeKeyAndVisible()
    }
    
    public func startTabBarApplication(window: UIWindow) {
        window.rootViewController = rootTabBarWireframe?.rootViewController
    }
}
