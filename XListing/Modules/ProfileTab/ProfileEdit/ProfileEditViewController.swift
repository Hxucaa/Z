//
//  ProfileEditViewController.swift
//  XListing
//
//  Created by Lance Zhu on 2016-02-05.
//  Copyright (c) 2016 Lance Zhu. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Cartography
import Whisper

final class ProfileEditViewController: XUIViewController {

    typealias InputViewModel = (loadFormData: Observable<Void>, submit: ControlEvent<Void>) -> ProfileEditViewModel
    // MARK: - UI Controls
    private var form: ProfileEditFormViewController! {
        didSet {
            addChildViewController(form)
            view.addSubview(form.view)
            form.didMoveToParentViewController(self)

            constrain(form.view) {
                $0.leading == $0.superview!.leading
                $0.top == $0.superview!.top + 44
                $0.trailing == $0.superview!.trailing
                $0.bottom == $0.superview!.bottom
            }
        }
    }

    // MARK: - Properties
    var hud: HUD!
    private var inputViewModel: InputViewModel!
    private var viewmodel: ProfileEditViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "编辑"
        view.backgroundColor = UIColor(red: 0.937, green: 0.937, blue: 0.957, alpha: 1)
        
        let dismissButton = UIBarButtonItem(barButtonSystemItem: .Stop, target: nil, action: nil)
        let saveButton = UIBarButtonItem(title: "递交", style: .Done, target: nil, action: nil)
        
        let navBar = navigationController?.navigationBar
        navBar?.barTintColor = UIColor.x_PrimaryColor()
        navBar?.tintColor = UIColor.whiteColor()
        
        // Create two buttons for the navigation item
        navigationItem.leftBarButtonItem = dismissButton
        navigationItem.rightBarButtonItem = saveButton
        navigationController?.setNavigationBarHidden(false, animated: false)
        
        
        dismissButton.rx_tap
            .subscribeNext { [weak self] in
                self?.navigationController?.popViewControllerAnimated(true)
            }
            .addDisposableTo(disposeBag)
        
        viewmodel = inputViewModel(
            loadFormData: Observable.just(),
            submit: saveButton.rx_tap
        )
        
        let formStatus = viewmodel.formStatus
        
        formStatus
            .filter { $0 == FormStatus.Loading }
            .driveNext { [weak self] _ in
                self?.hud.x_showWithStatusMessage("读取中...")
            }
            .addDisposableTo(disposeBag)
        
        formStatus.asObservable()
            .filter { $0 == FormStatus.Awaiting }
            .flatMap { _ in
                Observable.zip(
                    self.viewmodel.nicknameField,
                    self.viewmodel.whatsUpField,
                    self.viewmodel.profileImageField
                ) { ($0, $1, $2) }
            }
            .take(1)    // FIXME: takeUntil form dirty may be better?
            .subscribeNext { [weak self] (nicknameField, whatsUpField, profileImageField) in
                self?.hud.dismiss()
                self?.form = ProfileEditFormViewController(nickname: nicknameField.initialValue, profileImage: profileImageField.initialValue, whatsUp: whatsUpField.initialValue)
            }
            .addDisposableTo(disposeBag)
        
        formStatus
            .filter { $0 == FormStatus.Error }
            .driveNext { _ in
                // TODO: Replace the current error message implementation with something better
                Shout(Announcement(title: "请修正以下错误", subtitle: "Placeholder", image: nil, duration: 5.0, action: nil), to: self.form)
            }
            .addDisposableTo(disposeBag)
        
        let submittingForm = formStatus
            .filter { $0 == FormStatus.Submitting }
        
        submittingForm
            .driveNext { [weak self] _ in
                self?.hud.x_show()
            }
            .addDisposableTo(disposeBag)
        
//        viewmodel
        
        viewmodel.submissionEnabled
            .drive(saveButton.rx_enabled)
            .addDisposableTo(disposeBag)
        
        form.nicknameInput.asObserver()
            .bindTo(viewmodel.nicknameInput)
            .addDisposableTo(disposeBag)
        
        form.whatsUpInput.asObserver()
            .bindTo(viewmodel.whatsUpInput)
            .addDisposableTo(disposeBag)
        
        form.profileImageInput.asObserver()
            .bindTo(viewmodel.profileImageInput)
            .addDisposableTo(disposeBag)
    }

    func bindToViewModel(inputViewModel: InputViewModel) {
        self.inputViewModel = inputViewModel
    }
}
