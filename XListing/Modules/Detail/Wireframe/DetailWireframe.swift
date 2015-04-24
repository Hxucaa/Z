//
//  DetailWireframe.swift
//  XListing
//
//  Created by Lance Zhu on 2015-04-15.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation

private let DetailViewControllerIdentifier = "DetailViewController"

public class DetailWireframe : BaseWireframe, IDetailWireframe {
    
    private let detailVM: IDetailViewModel
    private var detailViewController: DetailViewController?
    
    public init(rootWireframe: IRootWireframe, detailViewModel: IDetailViewModel) {
        detailVM = detailViewModel
        super.init(rootWireframe: rootWireframe)
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
}

extension DetailWireframe : FeaturedListInterfaceToDetailInterfaceDelegate {
    public func pushInterface(businessViewModel: BusinessViewModel) {
        let injectedViewController = injectViewModelToViewController()
        injectedViewController.businessVM = businessViewModel
        rootWireframe.pushViewController(injectedViewController, animated: true)
    }
}
