////
////  NearbyWireframe.swift
////  XListing
////
////  Created by Lance Zhu on 2015-04-12.
////  Copyright (c) 2016 Lance Zhu. All rights reserved.
////
//
//import Foundation
//import UIKit
//
//private let NearbyViewControllerIdentifier = "NearbyViewController"
//private let NearbyStoryboardName = "Nearby"
//
//public protocol NearbyNavigationControllerDelegate : class {
//    func pushSocialBusiness<T : Business>(business: T)
//}
//
//public final class NearbyWireframe : INearbyWireframe {
//    
//    
//    public var rootViewController: UIViewController {
//        return initViewController()
//    }
//    
//    public weak var navigationControllerDelegate: NearbyNavigationControllerDelegate!
//    
//    private let businessService: IBusinessService
//    private let geoLocationService: IGeoLocationService
//    private let imageService: IImageService
//    
//    public required init(businessService: IBusinessService, geoLocationService: IGeoLocationService, imageService: IImageService) {
//        self.businessService = businessService
//        self.geoLocationService = geoLocationService
//        self.imageService = imageService
//    }
//    
//    /**
//    Inject view model to view controller.
//    
//    - returns: Properly configure and injected instance of NearbyViewController.
//    */
//    private func initViewController() -> NearbyViewController {
//        // retrieve view controller from storyboard
//        let viewController = UIStoryboard(name: NearbyStoryboardName, bundle: nil).instantiateViewControllerWithIdentifier(NearbyViewControllerIdentifier) as! NearbyViewController
//        let viewmodel = NearbyViewModel(businessService: businessService, geoLocationService: geoLocationService, imageService: imageService)
//        viewmodel.navigationDelegate = self
//        viewController.bindToViewModel(viewmodel)
//        
//        return viewController
//    }
//}
//
//extension NearbyWireframe : NearbyNavigationDelegate {
//    public func pushSocialBusiness<T : Business>(business: T) {
//        navigationControllerDelegate.pushSocialBusiness(business)
//    }
//}