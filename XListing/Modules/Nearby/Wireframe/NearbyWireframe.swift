//
//  NearbyWireframe.swift
//  XListing
//
//  Created by Lance Zhu on 2015-04-12.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation

private let NearbyViewControllerIdentifier = "NearbyViewController"

public class NearbyWireframe : BaseWireframe {
    
    private let nearbyVM: INearbyViewModel
    private let rootWireframe: RootWireframe
    private var nearbyVC: NearbyViewController?
    
    public init(rootWireframe: RootWireframe, nearbyViewModel: INearbyViewModel) {
        self.rootWireframe = rootWireframe
        nearbyVM = nearbyViewModel
    }
    
    /**
    Push NearbyViewController to NavigationControllerw.
    
    :param: window The UIWindow.
    */
    public func pushNearbyViewController() {
        let injectedViewController = injectViewModelToViewController()
        rootWireframe.pushViewController(injectedViewController, animated: true)
    }
    
    /**
    Inject view model to view controller.
    
    :returns: Properly configure and injected instance of NearbyViewController.
    */
    private func injectViewModelToViewController() -> NearbyViewController {
        // retrieve view controller from storyboard
        let viewController = getViewControllerFromStoryboard(NearbyViewControllerIdentifier) as! NearbyViewController
        viewController.nearbyVM = nearbyVM
        nearbyVC = viewController
        return viewController
    }
}