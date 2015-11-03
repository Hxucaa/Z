//
//  LandingPageViewController.swift
//  XListing
//
//  Created by Lance Zhu on 2015-07-12.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import UIKit
import ReactiveCocoa

private let LandingPageViewNibName = "LandingPageView"

public final class LandingPageViewController: XUIViewController {
    
    // MARK: - UI Controls
    private var landingPageView: LandingPageView!
    
    // MARK: - Properties
    
    private var viewmodel: ILandingPageViewModel!
    /// A disposable that will dispose of any number of other disposables.
    private let compositeDisposable = CompositeDisposable()
    
    // MARK: - Setups
    
    public override func loadView() {
        super.loadView()
        
        landingPageView = UINib(nibName: LandingPageViewNibName, bundle: nil).instantiateWithOwner(self, options: nil).first as! LandingPageView
        view = landingPageView
        
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        // add landing page as the first subview
        landingPageView.bindToViewModel(viewmodel)

        compositeDisposable += landingPageView.skipProxy
            .logLifeCycle(LogContext.Account, "landingPageView.skipProxy")
            .start(next: { [weak self] in
                self?.viewmodel.skipAccountModule()
            })
    }
    
    public override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        compositeDisposable += landingPageView.loginProxy
            .takeUntilViewWillDisappear(self)
            .logLifeCycle(LogContext.Account, "landingPageView.loginProxy")
            .start(next: { [weak self] in
                self?.viewmodel.goToLogInComponent()
            })
        
        compositeDisposable += landingPageView.signUpProxy
            .takeUntilViewWillDisappear(self)
            .logLifeCycle(LogContext.Account, "landingPageView.signUpProxy")
            .start(next: { [weak self] in
                // transition to sign up view
                self?.viewmodel.goToSignUpComponent()
            })

    }
    
    deinit {
        compositeDisposable.dispose()
        AccountLogVerbose("Landing Page View Controller deinitializes.")
    }
    
    // MARK: - Bindings
    
    public func bindToViewModel(viewModel: ILandingPageViewModel) {
        self.viewmodel = viewModel
    }
    
    // MARK: - Others
}