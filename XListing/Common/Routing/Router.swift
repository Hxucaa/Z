//
//  Router.swift
//  XListing
//
//  Created by Lance Zhu on 2016-03-29.
//  Copyright © 2016 ZenChat. All rights reserved.
//

import Foundation
import Swinject
import ReactiveCocoa
import Result

// TODO: Clean up this message. Possibly use Enum in place of function calls. Also somehow tie router with dependency injection?? Should also look into libraries that handle routing.

class Router : IRouter {
    typealias RouteCallback = Void -> Void
    
    var rootTabBar: RootTabBarController! {
        didSet {
            self.rootTabBar.selectedViewControllerCallback = { [unowned self] in
                self.activeNav = $0 as? UINavigationController
            }
        }
    }
    var featuredTab: FeaturedTabNavigationController!
    var accountNavgationController: AccountNavigationController!
    //    private var profileTab: ProfileTabNavigationController
    
    private var activeNav: UINavigationController!
    private weak var currentActiveViewController: UIViewController?
    
    var userDefaultsService: IUserDefaultsService!
    var meRepository: IMeRepository!
    var alert: IAlert!
    
    private let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    private var di: DependencyInjector {
        return appDelegate.DI
    }
    private var diResolver: ResolverType {
        return appDelegate.DI.assembler.resolver
    }
    private var window: UIWindow {
        return appDelegate.window!
    }
    
    func installRootViewController() {
        
        if !userDefaultsService.accountModuleSkipped && meRepository.me() == nil {
            
            window.rootViewController = accountNavgationController
            activeNav = accountNavgationController
        }
        else {
            startTabBarApplication()
        }
        window.makeKeyAndVisible()
    }
    
    func startTabBarApplication() {
        window.rootViewController = rootTabBar
        activeNav = featuredTab
    }
    
    func toSoclaBusiness(businessInfo: BusinessInfo) {
        activeNav.pushViewController(di.resolve(.SocialBusiness(businessInfo)), animated: true)
    }
    
    func toAccount(callback: RouteCallback?) {
        currentActiveViewController?.presentViewController(accountNavgationController, animated: false, completion: callback)
    }
    
    func toSignUp() {
        let vc = diResolver.resolve(SignUpViewController.self)!
        accountNavgationController.pushViewController(vc, animated: false)
    }
    
    func toLogIn() {
        let vc = diResolver.resolve(LogInViewController.self)!
        accountNavgationController.pushViewController(vc, animated: false)
    }
    
    func skipAccount() {
        
        userDefaultsService.accountModuleSkipped = true
        
        if let rootViewController = window.rootViewController where rootViewController is RootTabBarController {
            accountNavgationController.dismissViewControllerAnimated(true, completion: nil)
        }
        else {
            startTabBarApplication()
        }
    }
    
    var accountFinishedCallback: (() -> ())?
    func finishModule(callback: (CompletionHandler? -> ())? = nil) {
        
        if let rootViewController = window.rootViewController where rootViewController is RootTabBarController {
            accountNavgationController.dismissViewControllerAnimated(true, completion: accountFinishedCallback)
            accountFinishedCallback = nil
        }
        else {
            startTabBarApplication()
        }
    }
    
    func pop(animated: Bool = false) {
        activeNav?.popViewControllerAnimated(animated)
    }
    
    func presentError(error: INetworkError) {
        alert.presentError(error.message, navigationController: activeNav)
    }
    
    func popViewController(animated: Bool = false) {
        activeNav.popViewControllerAnimated(animated)
    }
}
