//
//  NearbyWireframe.swift
//  XListing
//
//  Created by Lance Zhu on 2015-04-12.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation

private let NearbyViewControllerIdentifier = "NearbyViewController"

public class NearbyWireframe : BaseWireframe, INearbyWireframe {
    
    private let nearbyVM: INearbyViewModel
    private var nearbyVC: NearbyViewController?
    
    public weak var detailInterfaceDelegate: NearbyInterfaceToDetailInterfaceDelegate?
    
    public init(rootWireframe: IRootWireframe, nearbyViewModel: INearbyViewModel) {
        nearbyVM = nearbyViewModel
        super.init(rootWireframe: rootWireframe)
    }
    
    /**
    Inject view model to view controller.
    
    :returns: Properly configure and injected instance of NearbyViewController.
    */
    private func initViewController() -> NearbyViewController {
        // retrieve view controller from storyboard
        let viewController = getViewControllerFromStoryboard(NearbyViewControllerIdentifier) as! NearbyViewController
        viewController.nearbyVM = nearbyVM
        viewController.navigationDelegate = self
        nearbyVC = viewController
        return viewController
    }
}

extension NearbyWireframe : FeaturedListInterfaceToNearbyInterfaceDelegate {
    public func transitionToNearbyInterfaceFromFeaturedList() {
        let injectedViewController = initViewController()
        rootWireframe.pushViewController(injectedViewController, animated: true)
    }
}

extension NearbyWireframe : NearbyViewControllerNavigationDelegate {
    public func pushDetail(businessViewModel: BusinessViewModel) {
        detailInterfaceDelegate?.transitionToDetailInterfaceFromNearbyInterface(businessViewModel)
    }
}