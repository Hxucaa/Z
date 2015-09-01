//
//  DetailWireframe.swift
//  XListing
//
//  Created by Lance Zhu on 2015-04-15.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import UIKit

private let DetailViewControllerIdentifier = "DetailViewController"
private let DetailStoryboardName = "Detail"

public final class DetailWireframe : IDetailWireframe {
    
    private let userService: IUserService
    private let participationService: IParticipationService
    private let geoLocationService: IGeoLocationService
    private let imageService: IImageService
    
    public required init(userService: IUserService, participationService: IParticipationService, geoLocationService: IGeoLocationService, imageService: IImageService) {
        
        self.userService = userService
        self.participationService = participationService
        self.geoLocationService = geoLocationService
        self.imageService = imageService
    }
    
    /**
    Inject ViewModel to view controller.
    
    :returns: Properly configured DetailViewController.
    */
    private func injectViewModelToViewController(businessModel: Business) -> DetailViewController {
        // retrieve view controller from storyboard
        let viewController = UIStoryboard(name: DetailStoryboardName, bundle: nil).instantiateViewControllerWithIdentifier(DetailViewControllerIdentifier) as! DetailViewController
        let detailViewModel = DetailViewModel(userService: userService, participationService: participationService, geoLocationService: geoLocationService, imageService: imageService, businessModel: businessModel)
        viewController.bindToViewModel(detailViewModel)
        
        return viewController
    }
}

//extension DetailWireframe : DetailRoute {
//    public func pushWithData<T : Business>(business: T) {
//        let injectedViewController = injectViewModelToViewController(business)
////        rootWireframe.pushViewController(injectedViewController, animated: true)
//    }
//}