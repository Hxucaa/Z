//
//  SignUpViewController.swift
//  XListing
//
//  Created by Lance Zhu on 2016-07-06.
//  Copyright (c) 2016 Lance Zhu. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import Cartography


final class SignUpViewController : XUIViewController, ViewModelBackedViewControllerType {
    
    typealias InputViewModel = (submitTrigger: ControlEvent<Void>, dummy: Void) -> ISignUpViewModel
    
    // MARK: - UI Controls
    private let form = SignUpFormViewController()
    var hud: HUD!
    
    // MARK: - Properties
    private var inputViewModel: InputViewModel!
    private var viewmodel: ISignUpViewModel!
    
    // MARK: - Setups
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(red: 0.937255, green: 0.937255, blue: 0.956863, alpha: 1)
        
        form.view.frame = CGRect(
            x: view.bounds.origin.x,
            y: view.bounds.origin.y + 44,
            width: view.bounds.size.width,
            height: view.bounds.size.height - 44
        )
        addChildViewController(form)
        view.addSubview(form.view)
        form.didMoveToParentViewController(self)
        
        
        let saveButton = UIBarButtonItem(title: "递交", style: .Done, target: nil, action: nil)
        navigationItem.rightBarButtonItem = saveButton
        
        viewmodel = inputViewModel(
            submitTrigger: saveButton.rx_tap,
            dummy: ()
        )
        
        form.bindToData(viewmodel.pickerLowerLimit, maximumDate: viewmodel.pickerUpperLimit)
        
        viewmodel.submissionEnabled
            .bindTo(saveButton.rx_enabled)
            .addDisposableTo(disposeBag)
        
        viewmodel.formStatus
            .subscribeNext { [weak self] in
                switch $0 {
                case .Error:
                    self?.hud.dismissWithFailedMessage()
                case .Submitting:
                    self?.hud.x_showWithStatusMessage()
                case .Submitted:
                    self?.hud.dismissWithCompletedMessage()
                    self?.viewmodel.finishModule { handler in
                        self?.dismissViewControllerAnimated(true, completion: handler)
                    }
                    self?.navigationController?.setNavigationBarHidden(false, animated: false)
                default:
                    break
                }
            }
            .addDisposableTo(disposeBag)
        
        form.outputs.username
            .bindTo(viewmodel.inputs.username)
            .addDisposableTo(disposeBag)
        
        form.outputs.password
            .bindTo(viewmodel.inputs.password)
            .addDisposableTo(disposeBag)
        
        form.outputs.nickname
            .bindTo(viewmodel.inputs.nickname)
            .addDisposableTo(disposeBag)
        
        form.outputs.birthday
            .bindTo(viewmodel.inputs.birthday)
            .addDisposableTo(disposeBag)
        
        form.outputs.gender
            .bindTo(viewmodel.inputs.gender)
            .addDisposableTo(disposeBag)
        
        form.outputs.profileImage
            .bindTo(viewmodel.inputs.profileImage)
            .addDisposableTo(disposeBag)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    // MARK: - Bindings
    
    func bindToViewModel(inputViewModel: InputViewModel) {
        self.inputViewModel = inputViewModel
    }
}
