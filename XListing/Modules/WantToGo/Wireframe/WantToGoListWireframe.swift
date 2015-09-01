//
//  WantToGoListWireframe.swift
//  XListing
//
//  Created by William Qi on 2015-06-27.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import UIKit

private let WantToGoListViewControllerIdentifier = "WantToGoListViewController"
private let WantToGoStoryboardName = "WantToGoList"

public final class WantToGoListWireframe : IWantToGoListWireframe {
    
    private let userService: IUserService
    private let participationService: IParticipationService
    private let imageService: IImageService
    
    public required init(userService: IUserService, participationService: IParticipationService, imageService: IImageService) {
        self.userService = userService
        self.participationService = participationService
        self.imageService = imageService
    }
    
    /**
    Inject ViewModel to view controller.
    
    :returns: Properly configured FeaturedListViewController.
    */
    private func initViewController(business: Business) -> WantToGoListViewController {
        // retrieve view controller from storyboard
        let viewController = UIStoryboard(name: WantToGoStoryboardName, bundle: nil).instantiateViewControllerWithIdentifier(WantToGoListViewControllerIdentifier) as! WantToGoListViewController
        let viewmodel = WantToGoListViewModel(userService: userService, participationService: participationService, imageService: imageService, business: business)
        viewController.bindToViewModel(viewmodel)
        
        return viewController
    }
}

//extension WantToGoListWireframe : WantToGoRoute {
//    public func pushWithData<T: Business>(business: T) {
//        let injectedViewController = initViewController(business)
////        rootWireframe.pushViewController(injectedViewController, animated: true)
//    }
//}





