//
//  IRouter.swift
//  XListing
//
//  Created by Lance Zhu on 2016-03-29.
//  Copyright © 2016 ZenChat. All rights reserved.
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
    func toSoclaBusiness(business: Business)
    
    func toSignUp()
    
    func toLogIn()
    
    func skipAccount()
    
    func finishModule(callback: (CompletionHandler? -> ())?)
    
    /**
     <#Description#>
     
     - parameter animated: <#animated description#>
     */
    func pop(animated: Bool)
}
