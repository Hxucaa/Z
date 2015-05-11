//
//  DetailWireframe.swift
//  XListing
//
//  Created by Lance Zhu on 2015-04-15.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import ReactKit

private let DetailViewControllerIdentifier = "DetailViewController"

public class DetailWireframe : BaseWireframe, IDetailWireframe {
    
    private var detailVM: IDetailViewModel
    private var detailViewController: DetailViewController?
    
    private let navigationNotificationReceiver: Stream<NSNotification?>
    
    public init(rootWireframe: IRootWireframe, detailViewModel: IDetailViewModel) {
        detailVM = detailViewModel
        
        navigationNotificationReceiver = Notification.stream(NavigationNotificationName.PushDetailModule, nil)
        
        super.init(rootWireframe: rootWireframe)
        
        navigationNotificationReceiver ~> { notification -> Void in
            let vm = (notification?.userInfo)!["viewmodel"] as! BusinessViewModel
            self.pushView(vm)
        }
    }
    
    /**
    Inject ViewModel to view controller.
    
    :returns: Properly configured DetailViewController.
    */
    private func injectViewModelToViewController() -> DetailViewController {
        // retrieve view controller from storyboard
        let viewController = getViewControllerFromStoryboard(DetailViewControllerIdentifier) as! DetailViewController
        viewController.detailVM = detailVM
        
        detailViewController = viewController
        return viewController
    }
    
    private func pushView(businessViewModel: BusinessViewModel) {
        let injectedViewController = injectViewModelToViewController()
        detailVM.business = businessViewModel
        rootWireframe.pushViewController(injectedViewController, animated: true)
    }
}