//
//  AccountWireframe.swift
//  XListing
//
//  Created by Lance Zhu on 2015-04-23.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import UIKit
import ReactiveCocoa

private let LandingPageViewControllerIdentifier = "LandingPageViewController"
private let SignUpViewControllerIdentifier = "SignUpViewController"
private let LogInViewControllerIdentifier = "LogInViewController"
private let AccountStoryboardName = "Account"

public protocol IAccountNavigator : class {
    func goToSignUpComponent()
    func goToLogInComponent()
    func goToFeaturedModule(callback: (CompletionHandler? -> ())?)
}

public final class AccountWireframe : IAccountWireframe {
    
    private let userService: IUserService
    private let userDefaultsService: IUserDefaultsService
    
    private var dismissCallback: CompletionHandler?
    
    private var moduleNavController: UINavigationController!
    
    public required init(userService: IUserService, userDefaultsService: IUserDefaultsService) {
        self.userService = userService
        self.userDefaultsService = userDefaultsService
    }
    
    private func injectViewModelToViewController(dismissCallback: CompletionHandler? = nil) -> LandingPageViewController {
        let viewController = UIStoryboard(name: AccountStoryboardName, bundle: nil).instantiateViewControllerWithIdentifier(LandingPageViewControllerIdentifier) as! LandingPageViewController
        let viewmodel = LandingPageViewModel(accountNavigator: self, userService: userService, userDefaultsService: userDefaultsService)
        viewController.bindToViewModel(viewmodel)
        
        return viewController
    }
}

//extension AccountWireframe : AccountRoute {
//    public func push() {
//        let injectedViewController = injectViewModelToViewController(dismissCallback: nil)
////        rootWireframe.pushViewController(injectedViewController, animated: true)
//    }
//    
//    public func present(completion: CompletionHandler?, dismissCallback: CompletionHandler?) {
//        self.dismissCallback = dismissCallback
//        
//        let injectedViewController = injectViewModelToViewController(dismissCallback: dismissCallback)
//        
//        moduleNavController = UINavigationController(rootViewController: injectedViewController)
//        
////        rootWireframe.presentViewController(moduleNavController, animated: true, completion: completion)
//    }
//}

extension AccountWireframe : IAccountNavigator {
    
    public func goToSignUpComponent() {
        let viewController = UIStoryboard(name: AccountStoryboardName, bundle: nil).instantiateViewControllerWithIdentifier(SignUpViewControllerIdentifier) as! SignUpViewController
        let viewmodel = SignUpViewModel(accountNavigator: self, userService: userService)
        viewController.viewmodel.put(viewmodel)
        
        if dismissCallback == nil {
//            rootWireframe.pushViewController(viewController, animated: false)
        }
        else {
            moduleNavController.pushViewController(viewController, animated: false)
        }
    }
    
    
    public func goToLogInComponent() {
        let viewController = UIStoryboard(name: AccountStoryboardName, bundle: nil).instantiateViewControllerWithIdentifier(LogInViewControllerIdentifier) as! LogInViewController
        let viewmodel = LogInViewModel(accountNavigator: self, userService: userService)
        viewController.viewmodel.put(viewmodel)
        
        if dismissCallback == nil {
//            rootWireframe.pushViewController(viewController, animated: false)
        }
        else {
            moduleNavController.pushViewController(viewController, animated: false)
        }
    }
    
    public func goToFeaturedModule(_ callback: (CompletionHandler? -> ())? = nil) {
        if let dismissCallback = dismissCallback {
            callback?(dismissCallback)
        }
        else {
//            router.pushFeatured()
        }
        self.dismissCallback = nil
        moduleNavController = nil
    }
}