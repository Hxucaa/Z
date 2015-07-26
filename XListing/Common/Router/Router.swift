//
//  Router.swift
//  XListing
//
//  Created by Lance Zhu on 2015-05-08.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation

public final class Router : IRouter {
    
    public class var sharedInstance : Router {
        struct Static {
            static var onceToken : dispatch_once_t = 0
            static var instance : Router? = nil
        }
        dispatch_once(&Static.onceToken) {
            Static.instance = Router()
        }
        return Static.instance!
    }
    
    private let userService: IUserService = UserService()
    
    public weak var nearbyRouteDelegate: NearbyRoute!
    public weak var featuredRouteDelegate: FeaturedRoute!
    public weak var detailRouteDelegate: DetailRoute!
    public weak var accountRouteDelegate: AccountRoute!
    public weak var profileRouteDelegate: ProfileRoute!
    public weak var wantToGoListRouteDelegate: WantToGoRoute!
    
    public func pushNearby() {
        nearbyRouteDelegate.push()
    }
    
    public func pushFeatured() {
        featuredRouteDelegate.push()
    }
    
    public func pushDetail<T: Business>(business: T) {
        detailRouteDelegate.pushWithData(business)
    }
    
    public func pushAccount() {
        accountRouteDelegate.push()
    }
    
    public func presentAccount(completion: CompletionHandler? = nil) {
        accountRouteDelegate.present(completion, dismissCallback: nil)
    }
    
    public func pushProfile() {
        requiredToManageAccountBeforeProceeding { [unowned self] in
            self.profileRouteDelegate.push()
        }
    }
    
    public func pushWantToGo<T: Business>(business: T) {
        wantToGoListRouteDelegate.pushWithData(business)
    }
    
    /**
    If user is not logged in yet, reroute to another view. Once that view is done, continue with original routing.
    
    :param: closure Original route.
    */
    private func requiredToManageAccountBeforeProceeding(closure: () -> ()) {
        
        if userService.isLoggedInAlready() {
            closure()
        }
        else {
            accountRouteDelegate.present(nil) {
                closure()
            }
        }
    }
}
