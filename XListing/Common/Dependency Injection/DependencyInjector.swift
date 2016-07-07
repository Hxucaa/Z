//
//  DependencyInjector.swift
//  XListing
//
//  Created by Lance Zhu on 2016-03-29.
//  Copyright © 2016 Lance Zhu. All rights reserved.
//

import Foundation
import Swinject
import Curry

enum ComponentDefinition {
    case SocialBusiness(SocialBusinessViewModel.Token)
    case BusinessDetail(BusinessDetailViewModel.Token)
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
                SocialBusinessAssembly(),
                ProfileAssembly()
            ]
        )
    }
    
    func resolve(component: ComponentDefinition) -> UIViewController {
        switch component {
        case let .SocialBusiness(token):
            let vc = resolver.resolve(SocialBusinessViewController.self)!
            vc.bindToViewModel(resolver.resolve(SocialBusinessViewController.InputViewModel.self, argument: token)!)
            return vc
        case let .BusinessDetail(token):
            let vc = resolver.resolve(BusinessDetailViewController.self)!
            vc.bindToViewModel(resolver.resolve(BusinessDetailViewController.InputViewModel.self, argument: token)!)
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
                r.profileTab = $0.resolve(ProfileTabNavigationController.self)!
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
                $1.setViewControllers([$0.resolve(FeaturedTabNavigationController.self)!, $0.resolve(ProfileTabNavigationController.self)!], animated: false)
                $1.meRepository = $0.resolve(IMeRepository.self)!
                $1.router = $0.resolve(IRouter.self)!
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
                    meRepository: $0.resolve(IMeRepository.self)!,
                    userRepository: $0.resolve(IUserRepository.self)!,
                    geoLocationService: $0.resolve(IGeoLocationService.self)!,
                    userDefaultsService: $0.resolve(IUserDefaultsService.self)!
                ))(())
                
                return inputVM
            }
            .inObjectScope(.Hierarchy)
    }
}

class ProfileAssembly : AssemblyType {
    func assemble(container: Container) {
        
        // navigation
        container
            .register(ProfileTabNavigationController.self) {
                ProfileTabNavigationController(rootViewController: $0.resolve(ProfileViewController.self)!)
            }
            .inObjectScope(.Hierarchy)
        
        // profile
        container
            .register(ProfileViewController.self) { _ in ProfileViewController() }
            .initCompleted {
                $1.bindToViewModel($0.resolve(ProfileViewController.InputViewModel.self)!)
                $1.bottomViewController = $0.resolve(ProfileBottomViewController.self)!
            }
            .inObjectScope(ObjectScope.Hierarchy)
        
        
        container
            .register(ProfileViewController.InputViewModel.self) {
                
                let inputVM = ProfileViewModel.inject((
                    router: $0.resolve(IRouter.self)!,
                    businessRepository: $0.resolve(IBusinessRepository.self)!,
                    meRepository: $0.resolve(IMeRepository.self)!,
                    geoLocationService: $0.resolve(IGeoLocationService.self)!,
                    userDefaultsService: $0.resolve(IUserDefaultsService.self)!
                ))(())
                
                return inputVM
            }
            .inObjectScope(.Hierarchy)
        
        container
            // TODO: the guideline of XLPager suggests to use storyboard for the view controller, however, it generates some error message.
//            .register(ProfileBottomViewController.self) { _ in storyboard.profileBottomViewController }
            .register(ProfileBottomViewController.self) { _ in ProfileBottomViewController() }
            .initCompleted {
                $1.participationListViewController = $0.resolve(ParticipationListViewController.self)!
                $1.photoManagerViewController = $0.resolve(PhotoManagerViewController.self)!
            }
            .inObjectScope(.Hierarchy)
        
        container
            .register(ParticipationListViewController.self) { _ in ParticipationListViewController() }
            .inObjectScope(.Hierarchy)
        
        container
            .register(PhotoManagerViewController.self) { _ in PhotoManagerViewController() }
            .inObjectScope(.Hierarchy)
        
        
        // profile edit
        container
            .register(ProfileEditViewController.self) { _ in ProfileEditViewController() }
            .initCompleted {
                $1.bindToViewModel($0.resolve(ProfileEditViewController.InputViewModel.self)!)
                $1.hud = $0.resolve(HUD.self)!
            }
            .inObjectScope(ObjectScope.Hierarchy)
        
        container
            .register(ProfileEditViewController.InputViewModel.self) {
                let inputVM = ProfileEditViewModel.inject((
                    router: $0.resolve(IRouter.self)!,
                    meRepository: $0.resolve(IMeRepository.self)!,
                    imageService: ImageService()
                ))(())
                
                return inputVM
            }
            .inObjectScope(ObjectScope.Hierarchy)
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
                $1.bindToViewModel($0.resolve(LandingPageViewController.InputViewModel.self)!)
            }
            .inObjectScope(ObjectScope.Hierarchy)
        
        container
            .register(LandingPageViewController.InputViewModel.self) {
                let inputVM = LandingPageViewModel.inject((
                    router: $0.resolve(IRouter)!,
                    meRepository: $0.resolve(IMeRepository.self)!
                ))(())
                
                return inputVM
            }
            .inObjectScope(.Hierarchy)
        
        // log in
        container
            .register(LogInViewController.self) { _ in
                storyboard.logInViewController
            }
            .initCompleted {
                $1.bindToViewModel($0.resolve(LogInViewController.InputViewModel.self)!)
                $1.hud = $0.resolve(HUD.self)!
            }
            .inObjectScope(ObjectScope.Hierarchy)
        
        container
            .register(LogInViewController.InputViewModel.self) {
                let inputVM = LogInViewModel.inject((
                    router: $0.resolve(IRouter)!,
                    meRepository: $0.resolve(IMeRepository.self)!
                ))(())
                
                return inputVM
            }
            .inObjectScope(.Hierarchy)
        
        // sign up
        container
            .register(SignUpViewController.self) { _ in
                storyboard.signUpViewController
            }
            .initCompleted {
                $1.bindToViewModel($0.resolve(SignUpViewController.InputViewModel.self)!)
                $1.hud = $0.resolve(HUD.self)!
        }
        
        container
            .register(SignUpViewController.InputViewModel.self) {
                let inputVM = SignUpViewModel.inject((
                    router: $0.resolve(IRouter.self)!,
                    $0.resolve(IMeRepository.self)!
                ))(())
                
                return inputVM
            }
            .inObjectScope(.Hierarchy)
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
        
        container
            .register(BusinessDetailViewController.self) { _ in BusinessDetailViewController() }
        
        container
            .register(BusinessDetailViewController.InputViewModel.self) { (resolver: ResolverType, token: BusinessInfo) in
                let partial = BusinessDetailViewModel.inject((
                    router: resolver.resolve(IRouter.self)!,
                    meRepository: resolver.resolve(IMeRepository.self)!,
                    businessRepository: resolver.resolve(IBusinessRepository.self)!,
                    geoLocationService: resolver.resolve(IGeoLocationService.self)!
                ))(token)
                
                return partial
            }
    }
}
