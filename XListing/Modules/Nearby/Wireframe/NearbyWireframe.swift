//
//  NearbyWireframe.swift
//  XListing
//
//  Created by Lance Zhu on 2015-04-12.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import UIKit

private let NearbyViewControllerIdentifier = "NearbyViewController"
private let NearbyStoryboardName = "Nearby"

public final class NearbyWireframe : INearbyWireframe {
    
    public var viewController: UIViewController {
        return initViewController()
    }
    
    private let router: IRouter
    private let businessService: IBusinessService
    private let geoLocationService: IGeoLocationService
    private let imageService: IImageService
    
    public required init(router: IRouter, businessService: IBusinessService, geoLocationService: IGeoLocationService, imageService: IImageService) {
        self.router = router
        self.businessService = businessService
        self.geoLocationService = geoLocationService
        self.imageService = imageService
    }
    
    /**
    Inject view model to view controller.
    
    :returns: Properly configure and injected instance of NearbyViewController.
    */
    private func initViewController() -> NearbyViewController {
        // retrieve view controller from storyboard
        let viewController = UIStoryboard(name: NearbyStoryboardName, bundle: nil).instantiateViewControllerWithIdentifier(NearbyViewControllerIdentifier) as! NearbyViewController
        let viewmodel = NearbyViewModel(router: router, businessService: businessService, geoLocationService: geoLocationService, imageService: imageService)
        
        viewController.bindToViewModel(viewmodel)
        
        return viewController
    }
}

extension NearbyWireframe : NearbyRoute {
    public func push() {
        let injectedViewController = initViewController()
//        rootWireframe.pushViewController(injectedViewController, animated: true)
    }
}