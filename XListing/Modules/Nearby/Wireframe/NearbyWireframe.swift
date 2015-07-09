//
//  NearbyWireframe.swift
//  XListing
//
//  Created by Lance Zhu on 2015-04-12.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation

private let NearbyViewControllerIdentifier = "NearbyViewController"

public final class NearbyWireframe : BaseWireframe, INearbyWireframe {
    
    private let router: IRouter
    private let businessService: IBusinessService
    private let geoLocationService: IGeoLocationService
    
    public required init(rootWireframe: IRootWireframe, router: IRouter, businessService: IBusinessService, geoLocationService: IGeoLocationService) {
        self.router = router
        self.businessService = businessService
        self.geoLocationService = geoLocationService
        
        super.init(rootWireframe: rootWireframe)
    }
    
    /**
    Inject view model to view controller.
    
    :returns: Properly configure and injected instance of NearbyViewController.
    */
    private func initViewController() -> NearbyViewController {
        // retrieve view controller from storyboard
        let viewController = getViewControllerFromStoryboard(NearbyViewControllerIdentifier) as! NearbyViewController
        let viewmodel = NearbyViewModel(router: router, businessService: businessService, geoLocationService: geoLocationService)
        
        viewController.bindToViewModel(viewmodel)
        
        return viewController
    }
}

extension NearbyWireframe : NearbyRoute {
    public func push() {
        let injectedViewController = initViewController()
        rootWireframe.pushViewController(injectedViewController, animated: true)
    }
}