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

private let EditProfileViewNibName = "EditProfileView"

public final class AccountWireframe : BaseWireframe, IAccountWireframe {
    
    private let navigator: INavigator
    private let userService: IUserService
    private var signUpVC: AccountViewController?
    
    public required init(rootWireframe: IRootWireframe, navigator: INavigator, userService: IUserService) {
        self.navigator = navigator
        self.userService = userService
        
        super.init(rootWireframe: rootWireframe)
        
        navigator.accountModuleNavigationNotificationSignal! ~> { notification -> Void in
            self.presentView()
        }
    }
    
    private func injectViewModelToViewController() -> AccountViewController {
        let viewmodel = AccountViewModel(userService: userService)
        let viewController = AccountViewController(accountVM: viewmodel, editProfileViewNibName: EditProfileViewNibName)
        signUpVC = viewController
        return viewController
    }
    
    
    private func presentView() {
        let injectedViewController = injectViewModelToViewController()
        rootWireframe.presentViewController(injectedViewController, animated: true)
    }
}