//
//  WantToGoListWireframe.swift
//  XListing
//
//  Created by William Qi on 2015-06-27.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation

private let WantToGoListViewControllerIdentifier = "WantToGoListViewController"

public final class WantToGoListWireframe : BaseWireframe, IWantToGoListWireframe {
    
    private let router: IRouter
    private let userService: IUserService
    private let participationService: IParticipationService
    private var wantToGoListViewController: WantToGoListViewController?
    
    public required init(rootWireframe: IRootWireframe, router: IRouter, userService: IUserService, participationService: IParticipationService) {
        self.router = router
        self.userService = userService
        self.participationService = participationService
        
        super.init(rootWireframe: rootWireframe)
    }
    
    /**
    Inject ViewModel to view controller.
    
    :returns: Properly configured FeaturedListViewController.
    */
    private func initViewController() -> WantToGoListViewController {
        // retrieve view controller from storyboard
        let viewController = getViewControllerFromStoryboard(WantToGoListViewControllerIdentifier) as! WantToGoListViewController
        let viewmodel = WantToGoListViewModel(router: router, userService: userService, participationService: participationService)
        viewController.bindToViewModel(viewmodel)
        
        wantToGoListViewController = viewController
        return viewController
    }
}

extension WantToGoListWireframe : WantToGoRoute {
    public func push() {
        let injectedViewController = initViewController()
        rootWireframe.pushViewController(injectedViewController, animated: true)
    }
}





