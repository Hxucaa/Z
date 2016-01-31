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
    func skipAccount()
    func finishModule(callback: (CompletionHandler? -> ())?)
}

public final class AccountWireframe : IAccountWireframe {
    
    private let userService: IUserService
    private let userDefaultsService: IUserDefaultsService
    
    public var finishedCallback: CompletionHandler?
    
    private lazy var moduleNavController: UINavigationController = UINavigationController(rootViewController: self.injectViewModelToViewController())
    public var rootViewController: UIViewController {
        return moduleNavController
    }
    
    public required init(userService: IUserService, userDefaultsService: IUserDefaultsService) {
        self.userService = userService
        self.userDefaultsService = userDefaultsService
    }
    
    private func injectViewModelToViewController() -> LandingPageViewController {
        let viewController = UIStoryboard(name: AccountStoryboardName, bundle: nil).instantiateViewControllerWithIdentifier(LandingPageViewControllerIdentifier) as! LandingPageViewController
        let viewmodel = LandingPageViewModel(accountNavigator: self, userService: userService)
        viewController.bindToViewModel(viewmodel)
        
        return viewController
    }
}

extension AccountWireframe : IAccountNavigator {
    
    public func goToSignUpComponent() {
        let viewController = UIStoryboard(name: AccountStoryboardName, bundle: nil).instantiateViewControllerWithIdentifier(SignUpViewControllerIdentifier) as! SignUpViewController
        
        moduleNavController.pushViewController(viewController, animated: false)
        
        let viewmodel = SignUpViewModel(accountNavigator: self, userService: userService)
        viewController.bindToViewModel(viewmodel)
    }
    
    
    public func goToLogInComponent() {
        let viewController = UIStoryboard(name: AccountStoryboardName, bundle: nil).instantiateViewControllerWithIdentifier(LogInViewControllerIdentifier) as! LogInViewController
        
        moduleNavController.pushViewController(viewController, animated: false)
        
        let viewmodel = LogInViewModel(accountNavigator: self, userService: userService)
        viewController.bindToViewModel(viewmodel)
    }
    
    public func skipAccount() {
        userDefaultsService.accountModuleSkipped = true
        
        let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate
        if let rootViewController = appDelegate?.window?.rootViewController where rootViewController is RootTabBarController {
            moduleNavController.dismissViewControllerAnimated(true, completion: nil)
        }
        else {
            appDelegate?.startTabBarApplication()
        }
    }
    
    public func finishModule(callback: (CompletionHandler? -> ())? = nil) {
        
        let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate
        if let rootViewController = appDelegate?.window?.rootViewController where rootViewController is RootTabBarController {
            moduleNavController.dismissViewControllerAnimated(true, completion: finishedCallback)
            finishedCallback = nil
        }
        else {
            appDelegate?.startTabBarApplication()
        }
    }
}