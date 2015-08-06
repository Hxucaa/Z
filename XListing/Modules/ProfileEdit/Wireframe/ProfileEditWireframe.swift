//
//  ProfileEditWireframe.swift
//  XListing
//
//  Created by Bruce Li on 2015-08-04.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import UIKit

private let ProfileEditViewControllerIdentifier = "ProfileEditViewController"
private let ProfileEditStoryboardName = "ProfileEdit"

public final class ProfileEditWireframe : BaseWireframe, IProfileEditWireframe {
    
    private let router: IRouter
    private let userService: IUserService
    
    public required init(rootWireframe: IRootWireframe, router: IRouter, userService: IUserService) {
        self.router = router
        self.userService = userService
        
        super.init(rootWireframe: rootWireframe)
    }
    
    private func injectViewModelToViewController(user: User, dismissCallback: CompletionHandler? = nil) -> ProfileEditViewController {
        let viewController = getViewControllerFromStoryboard(ProfileEditViewControllerIdentifier, storyboardName: ProfileEditStoryboardName) as! ProfileEditViewController
        let viewmodel = ProfileEditViewModel(userService: userService, userModel: user, dismissCallback: dismissCallback)
        viewController.bindToViewModel(viewmodel)
        
        return viewController
    }
}

extension ProfileEditWireframe : ProfileEditRoute {
    public func pushWithData<T: User>(user: T) {
        let injectedViewController = injectViewModelToViewController(user, dismissCallback: nil)
        rootWireframe.pushViewController(injectedViewController, animated: true)
    }
    
    public func presentWithData<T: User>(user: T, completion: CompletionHandler?, dismissCallback: CompletionHandler?) {
        let injectedViewController = injectViewModelToViewController(user, dismissCallback: dismissCallback)
        rootWireframe.presentViewController(injectedViewController, animated: true, completion: completion)
    }
}
