//
// Created by Lance on 15-05-06.
// Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import ReactKit

private let ProfileViewControllerIdentifier = "ProfileViewController"
private let StoryboardName = "Profile"

public final class ProfileWireframe : BaseWireframe, IProfileWireframe {
    
    private let navigator: INavigator
    private let userService: IUserService
    private var profileVC: ProfileViewController?

    public required init(rootWireframe: IRootWireframe, navigator: INavigator, userService: IUserService) {
        self.navigator = navigator
        self.userService = userService
        super.init(rootWireframe: rootWireframe)
        
        navigator.profileModuleNavigationNotificationSignal! ~> { notification -> Void in
            self.pushView()
        }
    }

    private func initViewController() -> ProfileViewController {
        let viewController = getViewControllerFromStoryboard(ProfileViewControllerIdentifier, storyboardName: StoryboardName) as! ProfileViewController
        viewController.bindToViewModel(ProfileViewModel(userService: userService))
        profileVC = viewController
        return viewController
    }
    
    public func pushView() {
        let injectedViewController = initViewController()
        rootWireframe.pushViewController(injectedViewController, animated: true)
    }
}