//
//  SignUpViewController.swift
//  XListing
//
//  Created by Lance Zhu on 2015-08-07.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import UIKit
import ReactiveCocoa
import Cartography

private let SignUpViewNibName = "SignUpView"

public final class SignUpViewController : XUIViewController {
    
    // MARK: - UI Controls
    private var signUpView: SignUpView!
    
    // MARK: - Proxies
    
    // MARK: - Properties
    public let viewmodel = MutableProperty<SignUpViewModel?>(nil)
    /// A disposable that will dispose of any number of other disposables.
    private let compositeDisposable = CompositeDisposable()
    
    // MARK: - Setups
    
    public override func loadView() {
        super.loadView()
        
        signUpView = UINib(nibName: SignUpViewNibName, bundle: nil).instantiateWithOwner(self, options: nil).first as! SignUpView
        view = signUpView
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        signUpView.viewmodel <~ viewmodel
        
        compositeDisposable += signUpView.goBackProxy
            |> logLifeCycle(LogContext.Account, "signUpView.goBackProxy")
            |> start(next: { [weak self] in
                if let this = self {
                    // transition to landing page view
                    //                    proxyNext(this._goBackSink, ())
                    self?.navigationController?.popViewControllerAnimated(false)
                }
            })
        
        compositeDisposable += signUpView.finishSignUpProxy
            |> logLifeCycle(LogContext.Account, "signUpView.finishSignUpProxy")
            |> start(next: { [weak self] in
                if let viewmodel = self?.viewmodel.value {
                    viewmodel.goToFeaturedModule { handler in
                        self?.dismissViewControllerAnimated(true, completion: handler)
                    }
                    
                    self?.navigationController?.setNavigationBarHidden(false, animated: false)
                }
            })
        
        compositeDisposable += signUpView.presentUIImagePickerProxy
            |> logLifeCycle(LogContext.Account, "signUpView.presentUIImagePickerProxy")
            |> start(next: { [weak self] imagePicker in
                // present image picker
                self?.presentViewController(imagePicker, animated: true, completion: nil)
            })
        
        compositeDisposable += signUpView.dismissUIImagePickerProxy
            |> logLifeCycle(LogContext.Account, "signUpView.dismissUIImagePickerProxy")
            |> start(next: { [weak self] handler in
                // dismiss image picker
                self?.dismissViewControllerAnimated(true, completion: handler)
            })
    }
    
    public override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    deinit {
        // Dispose signals before deinit.
        compositeDisposable.dispose()
        AccountLogVerbose("SignUp View Controller deinitializes.")
    }
}