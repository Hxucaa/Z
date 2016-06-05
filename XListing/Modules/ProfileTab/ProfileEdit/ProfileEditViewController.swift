//
//  ProfileEditViewController.swift
//  XListing
//
//  Created by Lance Zhu on 2016-02-05.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import UIKit
import ReactiveCocoa
import Result
import Cartography
import Whisper

final class ProfileEditViewController: XUIViewController {

    typealias InputViewModel = Void -> ProfileEditViewModel
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

        viewmodel = inputViewModel()
        
        let dismissAction = ReactiveCocoa.Action<UIBarButtonItem, Void, NoError> { [weak self]
            button in
            return SignalProducer { observer, disposable in
                self?.dismissViewControllerAnimated(true, completion: nil)
                observer.sendNext(())
                observer.sendCompleted()
            }
        }
        let dismissButton = UIBarButtonItem(barButtonSystemItem: .Stop, target: dismissAction.unsafeCocoaAction, action: CocoaAction.selector)


        let submitAction = ReactiveCocoa.Action<UIBarButtonItem, Void, NSError> (
            enabledIf: AnyProperty(
                initialValue: true,
                producer: viewmodel.isFormValid()
            )
        ) { button in
            return SignalProducer { observer, disposable in

//                // display HUD to indicate work in progress
//                // check for the validity of inputs first
//                disposable += self.hud.show()
//                    .promoteErrors(NSError)
//                    .flatMap(FlattenStrategy.Concat) { _ in this.viewmodel.updateProfile() }
//                    // does not `sendCompleted` because completion is handled when HUD is disappeared
//                    .start { event in
//                        switch event {
//                        case .Next(_):
//                            HUD.dismissWithNextMessage()
//                        case .Failed(let error):
//                            HUD.dismissWithFailedMessage()
//                            ProfileLogError(error.description)
//                            observer.sendFailed(error)
//                        case .Interrupted:
//                            observer.sendInterrupted()
//                        default: break
//                        }
//                    }

                // Subscribe to disappear notification
                disposable += self.hud.didDissappearNotification()
                    .startWithNext { status in

                        self.dismissViewControllerAnimated(true, completion: nil)

                        // completes the action
                        observer.sendNext(())
                        observer.sendCompleted()
                    }
            }
        }


        let saveButton = UIBarButtonItem(title: "递交", style: .Done, target: submitAction.unsafeCocoaAction, action: CocoaAction.selector)

        // disable button when submit action is disabled
        saveButton.rac_enabled <~ submitAction.enabled

        // disable button when submission is in progress
        saveButton.rac_enabled <~ submitAction.executing.producer
            .map { !$0 }

        let navBar = navigationController?.navigationBar
        navBar?.barTintColor = UIColor.x_PrimaryColor()
        navBar?.tintColor = UIColor.whiteColor()

        // Create two buttons for the navigation item
        navigationItem.leftBarButtonItem = dismissButton
        navigationItem.rightBarButtonItem = saveButton
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        viewmodel.isFormValid()
            .filter { !$0 }
            .flatMap(FlattenStrategy.Latest) {
                _ in self.viewmodel.formFormattedErrors()
            }
            .ignoreNil()
            .startWithNext {
                // TODO: Replace the current error message implementation with something better
                Shout(Announcement(title: "请修正以下错误", subtitle: $0, image: nil, duration: 5.0, action: nil), to: self.form)
            }
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        // fetch user info
        SignalProducer<Void, NSError> { observer, disposable in

            // display hud and retrieve user info
            disposable += self.hud.show()
                .promoteErrors(NSError)
                .flatMap(FlattenStrategy.Concat) { _ in self.viewmodel.getInitialValues() }
                .start { event in
                    switch event {
                    case .Failed(let error):
                        self.hud.dismissWithFailedMessage()
                        observer.sendFailed(error)
                    case .Interrupted:
                        observer.sendInterrupted()
                    default: break
                    }
            }

            // once user info is retrieved
            disposable += zip(
                self.viewmodel.nicknameField.producer.ignoreNil(),
                self.viewmodel.whatsUpField.producer.ignoreNil(),
                self.viewmodel.profileImageField.producer.ignoreNil()
                )
                .map { nicknameField, whatsUpField, profileImageField in
                    ProfileEditFormViewController(
                        nickname: (nicknameField.initialValue, { nicknameField.onChange($0) }),
                        profileImage: (profileImageField.initialValue, { profileImageField.onChange($0) }),
                        whatsUp: (whatsUpField.initialValue, { whatsUpField.onChange($0) })
                    )
                }
                .promoteErrors(NSError)
                .start { event in
                    switch event {
                    case .Next(let form):
                        // dismiss HUD based on the result of update profile signal
                        self.hud.dismiss()
                        self.form = form
                    case .Interrupted:
                        observer.sendInterrupted()
                    default: break
                    }
            }


            // Subscribe to disappear notification
            disposable += self.hud.didDissappearNotification()
                .startWithNext { status in

                    // completes the action
                    observer.sendNext(())
                    observer.sendCompleted()
            }
        }
        .start()
    }

    func bindToViewModel(inputViewModel: InputViewModel) {
        self.inputViewModel = inputViewModel
    }
}
