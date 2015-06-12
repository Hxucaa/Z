//
//  DetailWireframe.swift
//  XListing
//
//  Created by Lance Zhu on 2015-04-15.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation

private let DetailViewControllerIdentifier = "DetailViewController"

public final class DetailWireframe : BaseWireframe, IDetailWireframe {
    
    private let router: IRouter
    private let wantToGoService: IWantToGoService
    private let geoLocationService: IGeoLocationService
    private var detailViewController: DetailViewController?
    
    public required init(rootWireframe: IRootWireframe, router: IRouter, wantToGoService: IWantToGoService, geoLocationService: IGeoLocationService) {
        
        self.router = router
        self.wantToGoService = wantToGoService
        self.geoLocationService = geoLocationService
        
        super.init(rootWireframe: rootWireframe)
    }
    
    /**
    Inject ViewModel to view controller.
    
    :returns: Properly configured DetailViewController.
    */
    private func injectViewModelToViewController(businessModel: Business) -> DetailViewController {
        // retrieve view controller from storyboard
        let viewController = getViewControllerFromStoryboard(DetailViewControllerIdentifier) as! DetailViewController
        let detailViewModel = DetailViewModel(router: router, wantToGoService: wantToGoService, geoLocationService: geoLocationService, businessModel: businessModel)
        viewController.bindToViewModel(detailViewModel)
        
        detailViewController = viewController
        return viewController
    }
}

extension DetailWireframe : DetailRoute {
    public func pushWithData<T : Business>(business: T) {
        let injectedViewController = injectViewModelToViewController(business)
        rootWireframe.pushViewController(injectedViewController, animated: true)
    }
}