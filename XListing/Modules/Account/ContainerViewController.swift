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

    public var currentSegueID : String = LandingSegueID
    
    internal var landingPageVC : LandingPageViewController!
    internal var loginPageVC : LogInViewController!
    internal var signupPageVC : SignUpViewController!
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        self.currentSegueID = LandingSegueID
        self.performSegueWithIdentifier(self.currentSegueID, sender: nil)
        // Do any additional setup after loading the view.
    }

    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    public func switchToLogin () {
        self.currentSegueID = LoginSegueID
        self.performSegueWithIdentifier(self.currentSegueID, sender: nil)
    }
    
    public func switchToSignup () {
        self.currentSegueID = SignupSegueID
        self.performSegueWithIdentifier(self.currentSegueID, sender: nil)
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override public func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if (segue.identifier == LandingSegueID) {
            self.landingPageVC = segue.destinationViewController as! LandingPageViewController
        }
        
        if (segue.identifier == LoginSegueID) {
            self.loginPageVC = segue.destinationViewController as! LogInViewController
            
        }
        
        if (segue.identifier == SignupSegueID) {
            self.signupPageVC = segue.destinationViewController as! SignUpViewController
            
        }
        
        self.addChildViewController(segue.destinationViewController as! UIViewController)
        var destView = segue.destinationViewController.view!
        destView?.autoresizingMask = UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleHeight
        self.view.addSubview(destView!)
        segue.destinationViewController.didMoveToParentViewController(self)
        
    }


}
