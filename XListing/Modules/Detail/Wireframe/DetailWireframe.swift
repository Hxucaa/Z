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

public final class DetailWireframe : BaseWireframe, IDetailWireframe {
    
    private let navigator: INavigator
    private let wantToGoService: IWantToGoService
    private let geoLocationService: IGeoLocationService
    private var detailViewController: DetailViewController?
    
    public required init(rootWireframe: IRootWireframe, navigator: INavigator, wantToGoService: IWantToGoService, geoLocationService: IGeoLocationService) {
        
        self.navigator = navigator
        self.wantToGoService = wantToGoService
        self.geoLocationService = geoLocationService
        
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
    private func injectViewModelToViewController(businessModel: Business) -> DetailViewController {
        // retrieve view controller from storyboard
        let viewController = getViewControllerFromStoryboard(DetailViewControllerIdentifier) as! DetailViewController
        let detailViewModel = DetailViewModel(navigator: navigator, wantToGoService: wantToGoService, geoLocationService: geoLocationService, businessModel: businessModel)
        viewController.bindToViewModel(detailViewModel)
        
        detailViewController = viewController
        return viewController
    }
    
    private func pushView(businessModel: Business) {
        let injectedViewController = injectViewModelToViewController(businessModel)
        rootWireframe.pushViewController(injectedViewController, animated: true)
    }
}