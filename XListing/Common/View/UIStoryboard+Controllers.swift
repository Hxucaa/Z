//
//  UIStoryboard+Controllers.swift
//  XListing
//
//  Created by Lance Zhu on 2016-03-29.
//  Copyright © 2016 ZenChat. All rights reserved.
//

import Foundation

extension UIStoryboard {
    static var account: UIStoryboard {
        return UIStoryboard(name: "Account", bundle: nil)
    }
    
    static var nearby: UIStoryboard {
        return UIStoryboard(name: "Nearby", bundle: nil)
    }
    
    static var profile: UIStoryboard {
        return UIStoryboard(name: "Profile", bundle: nil)
    }
}

extension UIStoryboard {
    var landingPageViewController: LandingPageViewController {
        guard let vc = UIStoryboard.account.instantiateViewControllerWithIdentifier("LandingPageViewController") as? LandingPageViewController else {
            fatalError("LandingPageViewController couldn't be found in Storyboard file")
        }
        return vc
    }
    
    var logInViewController: LogInViewController {
        guard let vc = UIStoryboard.account.instantiateViewControllerWithIdentifier("LogInViewController") as? LogInViewController else {
            fatalError("LogInViewController couldn't be found in Storyboard file")
        }
        return vc
    }
    
    var signUpViewController: SignUpViewController {
        guard let vc = UIStoryboard.account.instantiateViewControllerWithIdentifier("SignUpViewController") as? SignUpViewController else {
            fatalError("SignUpViewController couldn't be found in Storyboard file")
        }
        return vc
    }
    
//    var nearbyViewController: NearbyViewController {
//        guard let vc = UIStoryboard.nearby.instantiateViewControllerWithIdentifier("NearbyViewController") as? NearbyViewController else {
//            fatalError("NearbyViewController couldn't be found in Storyboard file")
//        }
//        return vc
//        
//    }
    
    var profileBottomViewController: ProfileBottomViewController {
        guard let vc = UIStoryboard.profile.instantiateViewControllerWithIdentifier("ProfileBottomViewController") as? ProfileBottomViewController else {
            fatalError("ProfileBottomViewController couldn't be found in Storyboard file")
        }
        return vc
    }
}
