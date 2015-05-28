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

public class NearbyWireframe : BaseWireframe, INearbyWireframe {
    
    private let navigator: INavigator
    private let nearbyVM: INearbyViewModel
    private var nearbyVC: NearbyViewController?
    
    public init(rootWireframe: IRootWireframe, navigator: INavigator, nearbyViewModel: INearbyViewModel) {
        self.navigator = navigator
        nearbyVM = nearbyViewModel
        
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
        viewController.nearbyVM = nearbyVM
        
        nearbyVC = viewController
        return viewController
    }
    
    private func pushView() {
        let injectedViewController = initViewController()
        rootWireframe.pushViewController(injectedViewController, animated: true)
    }
}