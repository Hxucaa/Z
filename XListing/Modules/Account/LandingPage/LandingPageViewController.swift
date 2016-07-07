//
//  LandingPageViewController.swift
//  XListing
//
//  Created by Lance Zhu on 2016-07-05.
//  Copyright (c) 2016 Lance Zhu. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

private let LandingPageViewNibName = "LandingPageView"

final class LandingPageViewController: XUIViewController, ViewModelBackedViewControllerType {
    
    typealias InputViewModel = (signUpTrigger: ControlEvent<Void>, logInTrigger: ControlEvent<Void>, skipAccountTrigger: ControlEvent<Void>?) -> ILandingPageViewModel
    
    // MARK: - UI Controls
    private var landingPageView: LandingPageView!
    
    // MARK: - Properties
    private var inputViewModel: InputViewModel!
    private var viewmodel: ILandingPageViewModel!
    private var isRePrompt: Bool {
        if let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate, rootViewController = appDelegate.window?.rootViewController where rootViewController is RootTabBarController {
            return true
        }
        else {
            return false
        }
    }
    // MARK: - Setups
    
    override func loadView() {
        super.loadView()
        
        landingPageView = UINib(nibName: LandingPageViewNibName, bundle: nil).instantiateWithOwner(self, options: nil).first as! LandingPageView
        view = landingPageView
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.setNavigationBarHidden(true, animated: false)
        // add landing page as the first subview
        landingPageView.bindToData(isRePrompt)
        
        viewmodel = inputViewModel(
            signUpTrigger: landingPageView.signUpEvent,
            logInTrigger: landingPageView.loginEvent,
            skipAccountTrigger: landingPageView.skipEvent
        )
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    // MARK: - Bindings
    
    func bindToViewModel(inputViewModel: InputViewModel) {
        self.inputViewModel = inputViewModel
    }
    
    // MARK: - Others
}