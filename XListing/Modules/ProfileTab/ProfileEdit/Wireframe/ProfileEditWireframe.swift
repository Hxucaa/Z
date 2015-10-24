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

public final class ProfileEditWireframe : IProfileEditWireframe {

    private let userService: IUserService
    
    public required init(userService: IUserService) {
        self.userService = userService
    }
    
    private func injectViewModelToViewController(user: User) -> ProfileEditViewController {
        let viewController = UIStoryboard(name: ProfileEditStoryboardName, bundle: nil).instantiateViewControllerWithIdentifier(ProfileEditViewControllerIdentifier) as! ProfileEditViewController
        let viewmodel = ProfileEditViewModel(userService: userService, userModel: user)
        viewController.bindToViewModel(viewmodel)
        
        return viewController
    }


    public func viewController(user: User) -> ProfileEditViewController {
        return injectViewModelToViewController(user)
    }
}