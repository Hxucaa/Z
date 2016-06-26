//
//  IRouter.swift
//  XListing
//
//  Created by Lance Zhu on 2016-03-29.
//  Copyright © 2016 Lance Zhu. All rights reserved.
//

import Foundation

protocol IRouter : class {
    
    func installRootViewController()
    
    /**
     <#Description#>
     
     - parameter window: <#window description#>
     */
    func startTabBarApplication()
    
    /**
     <#Description#>
     
     - parameter business: <#business description#>
     */
    func toSoclaBusiness(businessInfo: BusinessInfo)
    
    func toBusinessDetail(businessInfo: BusinessInfo)
    
    func toSignUp()
    
    func toLogIn()
    
    func skipAccount()
    
    func presentAccountOnTabView(completion: (() -> ())?)
    
    var accountFinishedCallback: (() -> ())? { get set }
    func finishModule(callback: (CompletionHandler? -> ())?)
    
    /**
     <#Description#>
     
     - parameter animated: <#animated description#>
     */
    func pop(animated: Bool)
    
    func presentError(error: INetworkError)
    
    func popViewController(animated: Bool)
    
    func toProfileEdit()
}
