//
//  LandingPageViewController.swift
//  XListing
//
//  Created by Lance Zhu on 2015-07-12.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

private let LandingPageViewNibName = "LandingPageView"

final class LandingPageViewController: XUIViewController, ViewModelBackedViewControllerType {
    
    typealias ViewModelType = ILandingPageViewModel
    
    // MARK: - UI Controls
    private var landingPageView: LandingPageView!
    
    // MARK: - Properties
    
    private var viewmodel: ILandingPageViewModel!
    
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
        landingPageView.bindToViewModel(viewmodel)

//        compositeDisposable += landingPageView.skipProxy
//            .startWithNext { [weak self] in
//                self?.viewmodel.skipAccountModule()
//            }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

//        compositeDisposable += landingPageView.loginProxy
//            .takeUntilViewWillDisappear(self)
//            .startWithNext { [weak self] in
//                self?.viewmodel.goToLogInComponent()
//            }
        
//        compositeDisposable += landingPageView.signUpProxy
//            .takeUntilViewWillDisappear(self)
//            .startWithNext { [weak self] in
//                // transition to sign up view
//                self?.viewmodel.goToSignUpComponent()
//            }

    }
    
    func bindToViewModel(viewmodel: ILandingPageViewModel) {
        self.viewmodel = viewmodel
    }
    
    // MARK: - Others
}