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
    
    private let navigator: INavigator
    private let detailVM: IDetailViewModel
    private var detailViewController: DetailViewController?
    
    public init(rootWireframe: IRootWireframe, navigator: INavigator, detailViewModel: IDetailViewModel) {
        
        self.navigator = navigator
        detailVM = detailViewModel
        
        super.init(rootWireframe: rootWireframe)
        
        navigator.detailModuleNavigationNotificationSignal! ~> { notification -> Void in
            let vm = (notification?.userInfo)!["BusinessModel"] as! Business
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
    
    private func pushView(businessModel: Business) {
        let injectedViewController = injectViewModelToViewController()
        detailVM.business = businessModel
        rootWireframe.pushViewController(injectedViewController, animated: true)
    }
}