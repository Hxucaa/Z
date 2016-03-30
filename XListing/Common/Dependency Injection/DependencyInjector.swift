//
//  DependencyInjector.swift
//  XListing
//
//  Created by Hong Zhu on 2016-03-29.
//  Copyright © 2016 ZenChat. All rights reserved.
//

import Foundation
import Swinject
import Swiftz
import ReactiveCocoa

class DependencyInjector {
    
    let assembler: Assembler
    
    
    init() {
        assembler = try! Assembler(
            assemblies: [
                RootAssembly(),
                MainAssembly(),
                ServiceAssembly(),
                AccountAssembly(),
                FeaturedAssembly(),
                SocialBusinessAssembly()
            ]
        )
    }
}

class ServiceAssembly : AssemblyType {
    func assemble(container: Container) {
        
        container
            .register(IGeoLocationService.self) { _ in GeoLocationService() }
            .inObjectScope(ObjectScope.Hierarchy)
        container
            .register(IKeychainService.self) { _ in KeychainService() }
            .inObjectScope(ObjectScope.Hierarchy)
        container
            .register(IImageService.self) { _ in ImageService() }
            .inObjectScope(ObjectScope.Hierarchy)
        container
            .register(IUserDefaultsService.self) { _ in UserDefaultsService() }
            .inObjectScope(ObjectScope.Hierarchy)
        
        container
            .register(IBusinessRepository.self) {
                BusinessRepository(geolocationService: $0.resolve(IGeoLocationService.self)!)
            }
            .inObjectScope(ObjectScope.Hierarchy)
        container
            .register(IUserRepository.self) {
                UserRepository(geolocationService: $0.resolve(IGeoLocationService.self)!)
            }
            .inObjectScope(ObjectScope.Hierarchy)
        container
            .register(IMeRepository.self) {
                MeRepository(geolocationService: $0.resolve(IGeoLocationService.self)!)
            }
            .inObjectScope(ObjectScope.Hierarchy)
    }
}

class MainAssembly : AssemblyType {
    
    
    func assemble(container: Container) {
        
        container
            .register(IRouter.self) { _ in Router() }
            .initCompleted {
                let r = $1 as! Router
                r.meRepository = $0.resolve(IMeRepository.self)!
                r.userDefaultsService = $0.resolve(IUserDefaultsService.self)!
                r.rootTabBar = $0.resolve(RootTabBarController.self)!
                r.featuredTab = $0.resolve(FeaturedTabNavigationController.self)!
                r.accountNavgationController = $0.resolve(AccountNavigationController.self)!
            }
            .inObjectScope(ObjectScope.Hierarchy)
        
        
        // Components
        container
            .register(HUD.self) { _ in HUD() }
            .inObjectScope(ObjectScope.Hierarchy)
    }
}

class RootAssembly : AssemblyType {
    func assemble(container: Container) {
        
        // tab bar
        container
            .register(RootTabBarController.self) { _ in RootTabBarController() }
            .initCompleted {
                $1.setViewControllers([$0.resolve(FeaturedTabNavigationController.self)!], animated: false)
            }
            .inObjectScope(ObjectScope.Hierarchy)
    }
}

class FeaturedAssembly : AssemblyType {
    func assemble(container: Container) {
        
        // navigation
        container
            .register(FeaturedTabNavigationController.self) {
                FeaturedTabNavigationController(rootViewController: $0.resolve(FeaturedListViewController.self)!)
            }
            .inObjectScope(.Hierarchy)
        
        // root view controllers
//        typealias FeaturedListViewModelInput = (didSelectRow: SignalProducer<NSIndexPath, NoError>, test: Int) -> FeaturedListViewModel
        container
            .register(FeaturedListViewController.self) { _ in FeaturedListViewController() }
            .initCompleted {
                $1.bindToViewModel($0.resolve(FeaturedListViewController.InputViewModel.self)!)
            }
            .inObjectScope(ObjectScope.Hierarchy)
        
//        container
//            .register(IFeaturedListViewModel.self) {
//                FeaturedListViewModel(dep: (businessRepository: $0.resolve(IBusinessRepository.self)!, userRepository: $0.resolve(IUserRepository.self)!, geoLocationService: $0.resolve(IGeoLocationService.self)!, userDefaultsService: $0.resolve(IUserDefaultsService.self)!), input: (didSelectRow: undefined(), test: 5))
//            }
//            .initCompleted {
//                ($1 as! FeaturedListViewModel).router = $0.resolve(IRouter.self)!
//        }
        
        container
            .register(FeaturedListViewController.InputViewModel.self) {
                let initiazlier = curry(FeaturedListViewModel.init)
                let inputVM = initiazlier((businessRepository: $0.resolve(IBusinessRepository.self)!, userRepository: $0.resolve(IUserRepository.self)!, geoLocationService: $0.resolve(IGeoLocationService.self)!, userDefaultsService: $0.resolve(IUserDefaultsService.self)!))
                
                return inputVM
            }
    }
}

class AccountAssembly : AssemblyType {
    func assemble(container: Container) {
        let storyboard = UIStoryboard()
        
        // navigation
        container
            .register(AccountNavigationController.self) {
                AccountNavigationController(rootViewController: $0.resolve(LandingPageViewController.self)!)
            }
            .inObjectScope(ObjectScope.Hierarchy)
        
        // landing page
        container
            .register(LandingPageViewController.self) { _ in
                storyboard.landingPageViewController
            }
            .initCompleted {
                $1.bindToViewModel($0.resolve(ILandingPageViewModel.self)!)
            }
            .inObjectScope(ObjectScope.Hierarchy)
        
        container
            .register(ILandingPageViewModel.self) { LandingPageViewModel(meRepository: $0.resolve(IMeRepository.self)!) }
            .initCompleted { ($1 as! LandingPageViewModel).router = $0.resolve(IRouter.self)! }
            .inObjectScope(.Hierarchy)
        
        // log in
        container
            .register(LogInViewController.self) { _ in
                storyboard.logInViewController
            }
            .initCompleted {
                $1.bindToViewModel($0.resolve(ILogInViewModel.self)!)
                $1.hud = $0.resolve(HUD.self)!
        }
        
        container
            .register(ILogInViewModel.self) { LogInViewModel(dep: ($0.resolve(IRouter.self)!, $0.resolve(IMeRepository.self)!)) }
        
        // sign up
        container
            .register(SignUpViewController.self) { _ in
                storyboard.signUpViewController
            }
            .initCompleted {
                $1.bindToViewModel($0.resolve(ISignUpViewModel.self)!)
                $1.hud = $0.resolve(HUD.self)!
        }
        
        container
            .register(ISignUpViewModel.self) { SignUpViewModel(dep: ($0.resolve(IRouter.self)!, $0.resolve(IMeRepository.self)!)) }
    }
}

class SocialBusinessAssembly : AssemblyType {
    func assemble(container: Container) {
        
    }
}
