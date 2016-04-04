//
//  DependencyInjector.swift
//  XListing
//
//  Created by Lance Zhu on 2016-03-29.
//  Copyright © 2016 ZenChat. All rights reserved.
//

import Foundation
import Swinject
import ReactiveCocoa

enum ComponentDefinition {
    case SocialBusiness(SocialBusinessViewModel.Token)
    
}

class DependencyInjector {
    
    let assembler: Assembler
    
    private var resolver: ResolverType {
        return assembler.resolver
    }
    
    
    init() {
        // swiftlint:disable force_try
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
    
    func resolve(component: ComponentDefinition) -> UIViewController {
        switch component {
        case let .SocialBusiness(token):
            let vc = resolver.resolve(SocialBusinessViewController.self)!
            vc.bindToViewModel(resolver.resolve(SocialBusinessViewController.InputViewModel.self, argument: token)!)
            return vc
        }
        
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
            .register(ActivityIndicator.self) { _ in ActivityIndicator() }
            .inObjectScope(.Hierarchy)
        
        container
            .register(IWorkSchedulers.self) { _ in WorkSchedulers() }
            .inObjectScope(ObjectScope.Hierarchy)
        
        container
            .register(IBusinessRepository.self) {
                BusinessRepository(
                    geolocationService: $0.resolve(IGeoLocationService.self)!,
                    activityIndicator: $0.resolve(ActivityIndicator.self)!,
                    schedulers: $0.resolve(IWorkSchedulers.self)!
                )
            }
            .inObjectScope(ObjectScope.Hierarchy)
        container
            .register(IUserRepository.self) {
                UserRepository(
                    geolocationService: $0.resolve(IGeoLocationService.self)!,
                    activityIndicator: $0.resolve(ActivityIndicator.self)!,
                    schedulers: $0.resolve(IWorkSchedulers.self)!
                )
            }
            .inObjectScope(ObjectScope.Hierarchy)
        container
            .register(IMeRepository.self) {
                MeRepository(
                    geolocationService: $0.resolve(IGeoLocationService.self)!,
                    activityIndicator: $0.resolve(ActivityIndicator.self)!,
                    schedulers: $0.resolve(IWorkSchedulers.self)!
                )
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
                r.alert = $0.resolve(IAlert.self)!
            }
            .inObjectScope(ObjectScope.Hierarchy)
        
        // Components
        container
            .register(HUD.self) { _ in HUD() }
            .inObjectScope(ObjectScope.Hierarchy)
        
        container
            .register(IAlert.self) { _ in Alert() }
            .inObjectScope(.Hierarchy)
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
        
        container
            .register(FeaturedListViewController.self) { _ in FeaturedListViewController() }
            .initCompleted {
                $1.bindToViewModel($0.resolve(FeaturedListViewController.InputViewModel.self)!)
            }
            .inObjectScope(ObjectScope.Hierarchy)
        
        
        container
            .register(FeaturedListViewController.InputViewModel.self) {
                
                let inputVM = FeaturedListViewModel.inject((
                    router: $0.resolve(IRouter.self)!,
                    businessRepository: $0.resolve(IBusinessRepository.self)!,
                    userRepository: $0.resolve(IUserRepository.self)!,
                    geoLocationService: $0.resolve(IGeoLocationService.self)!,
                    userDefaultsService: $0.resolve(IUserDefaultsService.self)!
                ))(())
                
                return inputVM
            }
            .inObjectScope(.Hierarchy)
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
        
        container
            .register(SocialBusinessViewController.self) { _ in
                SocialBusinessViewController()
            }
        
        container
            .register(SocialBusinessViewController.InputViewModel.self) { (resolver: ResolverType, token: BusinessInfo) in
                let partial = SocialBusinessViewModel.inject((
                    router: resolver.resolve(IRouter.self)!,
                    meRepository: resolver.resolve(IMeRepository.self)!,
                    businessRepository: resolver.resolve(IBusinessRepository.self)!,
                    userRepository: resolver.resolve(IUserRepository.self)!,
                    geoLocationService: resolver.resolve(IGeoLocationService.self)!
                ))(token)
                
                
                return partial
        }
        

    }
}
