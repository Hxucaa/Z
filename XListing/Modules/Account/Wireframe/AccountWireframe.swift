//
//  AccountWireframe.swift
//  XListing
//
//  Created by Lance Zhu on 2015-04-23.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import ReactKit
import UIKit

private let SignUpViewNibName = "SignUpView"

public final class AccountWireframe : BaseWireframe, IAccountWireframe {
    
    private let navigator: INavigator
    private let userService: IUserService
    private let keychainService: IKeychainService
    private var signUpVC: SignUpViewController?
    
    public required init(rootWireframe: IRootWireframe, navigator: INavigator, userService: IUserService, keychainService: IKeychainService) {
        self.navigator = navigator
        self.userService = userService
        self.keychainService = keychainService
        
        super.init(rootWireframe: rootWireframe)
        
        navigator.accountModuleNavigationNotificationSignal! ~> { notification -> Void in
            self.presentView()
        }
    }
    
    private func injectViewModelToViewController() -> SignUpViewController {
        let viewmodel = AccountViewModel(userService: userService, keychainService: keychainService)
        let viewController = SignUpViewController(accountVM: viewmodel, signUpViewNibName: SignUpViewNibName)
        signUpVC = viewController
        return viewController
    }
    
    
    private func presentView() {
        let injectedViewController = injectViewModelToViewController()
//        rootWireframe.pushViewController(injectedViewController, animated: true)
        rootWireframe.presentViewController(injectedViewController, animated: true)
    }
}