//
// Created by Lance on 15-05-06.
// Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation

private let ProfileViewControllerIdentifier = "ProfileViewController"
private let StoryboardName = "Profile"

public class ProfileWireframe : BaseWireframe, IProfileWireframe {

    private let profileVM: IProfileViewModel
    private var profileVC: ProfileViewController?

    public init(rootWireframe: IRootWireframe, profileViewModel: IProfileViewModel) {
        self.profileVM = profileViewModel
        super.init(rootWireframe: rootWireframe)
    }

    private func initViewController() -> ProfileViewController {
        let viewController = getViewControllerFromStoryboard(ProfileViewControllerIdentifier, storyboardName: StoryboardName) as! ProfileViewController
        viewController.profileVM = profileVM
        profileVC = viewController
        return viewController
    }

}

extension ProfileWireframe : ProfileModule {
    public func pushView() {
        let injectedViewController = initViewController()
        rootWireframe.pushViewController(injectedViewController, animated: true)
    }
}