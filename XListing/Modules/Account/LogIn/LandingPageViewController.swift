//
//  LandingPageViewController.swift
//  XListing
//
//  Created by Bruce Li on 2015-06-13.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import UIKit

public final class LandingPageViewController: UIViewController {

    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var skipButton: UIButton!
    
    private var containerVC : ContainerViewController!
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        self.containerVC = self.parentViewController as! ContainerViewController
        loginButton.addTarget(self, action: "switchToLoginView", forControlEvents: UIControlEvents.TouchUpInside)
        signupButton.addTarget(self, action: "switchToSignupView", forControlEvents: UIControlEvents.TouchUpInside)
        skipButton.addTarget(self, action: "skipToApp", forControlEvents: UIControlEvents.TouchUpInside)
        // Do any additional setup after loading the view.
    }

    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func switchToLoginView() {
        self.containerVC.switchToLogin()
    }
    
    func switchToSignupView() {
        self.containerVC.switchToSignup()
    }
    
    func skipToApp() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
