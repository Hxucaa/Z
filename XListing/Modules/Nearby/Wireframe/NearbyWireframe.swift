//
//  NearbyWireframe.swift
//  XListing
//
//  Created by Lance Zhu on 2015-04-12.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation

private let NearbyViewControllerIdentifier = "NearbyViewController"
private let NearbyStoryboardName = "Nearby"

public final class NearbyWireframe : BaseWireframe, INearbyWireframe {
    
    private let router: IRouter
    private let businessService: IBusinessService
    private let geoLocationService: IGeoLocationService
    private let imageService: IImageService
    
    public required init(rootWireframe: IRootWireframe, router: IRouter, businessService: IBusinessService, geoLocationService: IGeoLocationService, imageService: IImageService) {
        self.router = router
        self.businessService = businessService
        self.geoLocationService = geoLocationService
        self.imageService = imageService
        
        super.init(rootWireframe: rootWireframe)
    }
    
    /**
    Inject view model to view controller.
    
    :returns: Properly configure and injected instance of NearbyViewController.
    */
    private func initViewController() -> NearbyViewController {
        // retrieve view controller from storyboard
        let viewController = getViewControllerFromStoryboard(NearbyViewControllerIdentifier, storyboardName: NearbyStoryboardName) as! NearbyViewController
        let viewmodel = NearbyViewModel(router: router, businessService: businessService, geoLocationService: geoLocationService, imageService: imageService)
        
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