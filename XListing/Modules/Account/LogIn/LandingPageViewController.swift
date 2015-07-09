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
    @IBOutlet weak var dividerLabel: ShadowLabel!
    @IBOutlet weak var backgroundLabel: UILabel!
    
    // MARK: Actions
    private var dismissViewButtonAction: CocoaAction!
    
    public weak var delegate: LandingViewDelegate!
    
    private var viewmodel: LandingPageViewModel!
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setUpLabels()
        setupDismissViewButton()
        setUpLoginSignupButtons()
        // Do any additional setup after loading the view.
    }
    
    public override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        dismissViewButtonAction = nil
    }

    public func bindToViewModel(viewmodel: LandingPageViewModel) {
        self.viewmodel = viewmodel
    }
    
    public override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func setUpLabels () {
        self.backgroundLabel.layer.masksToBounds = true;
        self.backgroundLabel.layer.cornerRadius = 8;
        self.dividerLabel.layer.masksToBounds = false
        self.dividerLabel.layer.shadowRadius = 3.0
        self.dividerLabel.layer.shadowOpacity = 0.5
        self.dividerLabel.layer.shadowOffset = CGSizeZero;
    }
    
    private func setUpLoginSignupButtons () {
        loginButton.addTarget(delegate, action: "switchToLoginView", forControlEvents: UIControlEvents.TouchUpInside)
        signupButton.addTarget(delegate, action: "switchToSignUpView", forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    private func setupDismissViewButton() {
        // Action to an UI event
        let dismissView = Action<Void, Void, NoError> {
            return SignalProducer { sink, disposable in
                self.viewmodel.skipAccount() {
                    self.dismissViewControllerAnimated(true, completion: nil)
                }
            }
        }
        
        // Bridging
        dismissViewButtonAction = CocoaAction(dismissView, input: ())
        
        skipButton.addTarget(dismissViewButtonAction, action: CocoaAction.selector, forControlEvents: .TouchUpInside)
    }

}
