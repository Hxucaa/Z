//
//  NearbyWireframe.swift
//  XListing
//
//  Created by Lance Zhu on 2015-04-12.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import ReactKit

private let NearbyViewControllerIdentifier = "NearbyViewController"

public final class NearbyWireframe : BaseWireframe, INearbyWireframe {
    
    private let navigator: INavigator
    private let businessService: IBusinessService
    private let geoLocationService: IGeoLocationService
    private var nearbyVC: NearbyViewController?
    
    public required init(rootWireframe: IRootWireframe, navigator: INavigator, businessService: IBusinessService, geoLocationService: IGeoLocationService) {
        self.navigator = navigator
        self.businessService = businessService
        self.geoLocationService = geoLocationService
        
        super.init(rootWireframe: rootWireframe)
        
        navigator.nearbyModuleNavigationNotificationSignal! ~> { notification -> Void in
            self.pushView()
        }
        
    }
    
    /**
    Inject view model to view controller.
    
    :returns: Properly configure and injected instance of NearbyViewController.
    */
    private func initViewController() -> NearbyViewController {
        // retrieve view controller from storyboard
        let viewController = getViewControllerFromStoryboard(NearbyViewControllerIdentifier) as! NearbyViewController
        let viewmodel = NearbyViewModel(navigator: navigator, businessService: businessService, geoLocationService: geoLocationService)
        
        viewController.bindToViewModel(viewmodel)
        
        nearbyVC = viewController
        return viewController
    }
    
    private func pushView() {
        let injectedViewController = initViewController()
        rootWireframe.pushViewController(injectedViewController, animated: true)
    }
}