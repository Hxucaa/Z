//
// Created by Lance on 15-05-06.
// Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation

private let ProfileViewControllerIdentifier = "ProfileViewController"
private let StoryboardName = "Profile"

public final class ProfileWireframe : BaseWireframe, IProfileWireframe {
    
    private let router: IRouter
    private let userService: IUserService
    private var profileVC: ProfileViewController?

    public required init(rootWireframe: IRootWireframe, router: IRouter, userService: IUserService) {
        self.router = router
        self.userService = userService
        super.init(rootWireframe: rootWireframe)
    }

    private func initViewController() -> ProfileViewController {
        let viewController = getViewControllerFromStoryboard(ProfileViewControllerIdentifier, storyboardName: StoryboardName) as! ProfileViewController
        viewController.bindToViewModel(ProfileViewModel(userService: userService))
        profileVC = viewController
        return viewController
    }
}

extension ProfileWireframe : ProfileRoute {
    public func push() {
        let injectedViewController = initViewController()
        rootWireframe.pushViewController(injectedViewController, animated: true)
    }
}