////
////  ProfileEditWireframe.swift
////  XListing
////
////  Created by Lance Zhu on 2016-02-17.
////  Copyright (c) 2015 ZenChat. All rights reserved.
////
//
//import Foundation
//import UIKit
//
//
//public final class ProfileEditWireframe : IProfileEditWireframe {
//
//    private let meService: IMeService
//    private let imageService: IImageService
//    
//    public required init(meService: IMeService, imageService: IImageService) {
//        self.meService = meService
//        self.imageService = imageService
//    }
//    
//    private func injectViewModelToViewController() -> UIViewController {
//        let navController = UINavigationController()
//        let viewController = ProfileEditViewController()
//        let viewmodel = ProfileEditViewModel(meService: meService, imageService: imageService)
//        viewController.bindToViewModel(viewmodel)
//        
//        navController.pushViewController(viewController, animated: true)
//        return navController
//    }
//
//
//    public func viewController() -> UIViewController {
//        return injectViewModelToViewController()
//    }
//}