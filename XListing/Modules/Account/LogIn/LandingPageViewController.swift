//
//  LandingPageViewController.swift
//  XListing
//
//  Created by Bruce Li on 2015-06-13.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import UIKit
import ReactiveCocoa

public final class LandingPageViewController: UIViewController {

    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var skipButton: UIButton!
    
    private var dismissViewButtonAction: CocoaAction!
    
    internal var containerVC : ContainerViewController!
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        setupDismissViewButton()
        setUpLoginSignupButtons()
        // Do any additional setup after loading the view.
    }

    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setUpLoginSignupButtons () {
        loginButton.addTarget(self, action: "switchToLoginView", forControlEvents: UIControlEvents.TouchUpInside)
        signupButton.addTarget(self, action: "switchToSignupView", forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    func switchToLoginView() {
        self.containerVC.switchToLogin()
    }
    
    func switchToSignupView() {
        self.containerVC.switchToSignup()
    }
    
    private func setupDismissViewButton() {
        // Action to an UI event
        let dismissView = Action<Void, Void, NoError> {
            return SignalProducer { sink, disposable in
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        }
        
        // Bridging
        dismissViewButtonAction = CocoaAction(dismissView, input: ())
        
        skipButton.addTarget(dismissViewButtonAction, action: CocoaAction.selector, forControlEvents: .TouchUpInside)
    }

}
