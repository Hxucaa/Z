//
//  ContainerViewController.swift
//  XListing
//
//  Created by Bruce Li on 2015-06-13.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import UIKit

private let LandingSegueID = "landingSegue"
private let LoginSegueID = "loginSegue"
private let SignupSegueID = "signupSegue"
private let EditProfileSegueID = "editProfileSegue"

public final class ContainerViewController: UIViewController {

    internal var viewmodel: IAccountViewModel!
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        self.performSegueWithIdentifier(LandingSegueID, sender: nil)
        // Do any additional setup after loading the view.
    }

    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    public func switchToLogin () {
        self.performSegueWithIdentifier(LoginSegueID, sender: nil)
    }
    
    public func switchToSignup () {
        self.performSegueWithIdentifier(SignupSegueID, sender: nil)
    }
    
    public func switchToLanding () {
        self.performSegueWithIdentifier(LandingSegueID, sender: nil)
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override public func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if (segue.identifier == LandingSegueID) {
            var landingPageVC = segue.destinationViewController as! LandingPageViewController
            landingPageVC.containerVC = self
            swapToViewController(landingPageVC)
            
        }
        
        if (segue.identifier == LoginSegueID) {
            var loginPageVC = segue.destinationViewController as! LogInViewController
            loginPageVC.bindToViewModel(viewmodel.logInViewModel)
            loginPageVC.containerVC = self
            swapToViewController(loginPageVC)
            
        }
        
        if (segue.identifier == SignupSegueID) {
            var signupPageVC = segue.destinationViewController as! SignUpViewController
            signupPageVC.bindToViewModel(viewmodel.signUpViewModel, editProfileViewmodel: viewmodel.editProfileViewModel)
            signupPageVC.containerVC = self
            swapToViewController(signupPageVC)
            
        }
    }
    
    public func swapToViewController(toVC: UIViewController) {
        
        // for initial launch, instantiate a new child view controller
        // for all other times, just swap out the view controllers
        if (self.childViewControllers.count > 0) {
            
        var fromVC = self.childViewControllers[0] as! UIViewController
        
        toVC.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)
        fromVC.willMoveToParentViewController(nil)
        self.addChildViewController(toVC)
        self.transitionFromViewController(fromVC, toViewController: toVC, duration: 1.0, options: UIViewAnimationOptions.TransitionFlipFromLeft, animations: nil) { (finished) -> Void in
            fromVC.removeFromParentViewController()
            toVC.didMoveToParentViewController(self)
        }
        } else {
            instantiateViewController(toVC)
        }
    }
    
    public func instantiateViewController (vc: UIViewController) {
        self.addChildViewController(vc)
        var destView = vc.view!
        destView.autoresizingMask = UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleHeight
        self.view.addSubview(destView)
        vc.didMoveToParentViewController(self)
    }


}
