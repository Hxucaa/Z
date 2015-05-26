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

public class AccountWireframe : BaseWireframe, IAccountWireframe {
    
    private let navigator: INavigator
    private let accountVM: IAccountViewModel
    private var signUpVC: SignUpViewController?
    
    public init(rootWireframe: IRootWireframe, navigator: INavigator, accountVM: IAccountViewModel) {
        self.navigator = navigator
        self.accountVM = accountVM
        
        super.init(rootWireframe: rootWireframe)
        
        navigator.accountModuleNavigationNotificationSignal! ~> { notification -> Void in
            self.pushView()
        }
    }
    
    private func injectViewModelToViewController() -> SignUpViewController {
        let viewController = SignUpViewController(accountVM: accountVM, signUpViewNibName: SignUpViewNibName)
        signUpVC = viewController
        return viewController
    }
    
    
    private func pushView() {
        let injectedViewController = injectViewModelToViewController()
//        rootWireframe.pushViewController(injectedViewController, animated: true)
        rootWireframe.presentViewController(injectedViewController, animated: true)
    }
}