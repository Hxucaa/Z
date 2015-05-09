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
    
    private let nearbyVM: INearbyViewModel
    private var nearbyVC: NearbyViewController?
    
    private let navigationNotificationReceiver: Stream<NSNotification?>
    
    public init(rootWireframe: IRootWireframe, nearbyViewModel: INearbyViewModel) {
        nearbyVM = nearbyViewModel
        
        navigationNotificationReceiver = Notification.stream(NavigationNotificationName.PushNearbyModule, nil)
        
        super.init(rootWireframe: rootWireframe)
        
        navigationNotificationReceiver ~> { notification -> Void in
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