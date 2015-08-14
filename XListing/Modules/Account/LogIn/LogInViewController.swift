//
//  LogInViewController.swift
//  XListing
//
//  Created by Lance Zhu on 2015-08-12.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import UIKit
import ReactiveCocoa
import Cartography

private let LogInViewNibName = "LogInView"

public final class LogInViewController : XUIViewController {
    
    // MARK: - UI Controls
    private var logInView: LogInView!
    
    // MARK: - Proxies
    
    // MARK: - Properties
    public let viewmodel = MutableProperty<LogInViewModel?>(nil)
    /// A disposable that will dispose of any number of other disposables.
    private let compositeDisposable = CompositeDisposable()
    
    // MARK: - Setups
    
    public override func loadView() {
        super.loadView()
        
        logInView = UINib(nibName: LogInViewNibName, bundle: nil).instantiateWithOwner(self, options: nil).first as! LogInView
        view = logInView
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        viewmodel.producer
            |> ignoreNil
            |> start(next: { [weak self] viewmodel in
                self?.logInView.bindToViewModel(viewmodel)
            })
    }
    
    public override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        
        compositeDisposable += logInView.goBackProxy
            |> logLifeCycle(LogContext.Account, "logInView.goBackProxy")
            |> start(next: { [weak self] in
                // transition to landing page view
                self?.navigationController?.popViewControllerAnimated(false)
            })
        
        compositeDisposable += logInView.finishLoginProxy
            |> logLifeCycle(LogContext.Account, "logInView.finishLoginProxy")
            |> start(next: { [weak self] in
                if let viewmodel = self?.viewmodel.value {
                    viewmodel.goToFeaturedModule { handler in
                        self?.dismissViewControllerAnimated(true, completion: handler)
                    }
//                    if viewmodel.gotoNextModuleCallback == nil {
//                        viewmodel.pushFeaturedModule()
//                    }
//                    else {
//                        // dismiss account module, and go to the next module
//                        self?.dismissViewControllerAnimated(true, completion: viewmodel.gotoNextModuleCallback)
//                    }
                    self?.navigationController?.setNavigationBarHidden(false, animated: false)
                }
            })
    }
}