//
//  ProfileEditViewController.swift
//  XListing
//
//  Created by Lance Zhu on 2016-02-05.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import UIKit
import ReactiveCocoa
import Cartography
import Whisper

public final class ProfileEditViewController: XUIViewController {
    
    // MARK: - UI Controls
//    private let navBar = UINavigationBar()
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
    private var viewmodel: ProfileEditViewModel! {
        didSet {
            let s = SignalProducer<Void, NSError> { observer, disposable in
                
                disposable += HUD.show()
                    .promoteErrors(NSError)
                    .flatMap(FlattenStrategy.Concat) { _ in self.viewmodel.getInitialValues() }
                    .flatMap(FlattenStrategy.Concat) { _ in
                        return combineLatest(self.viewmodel.nicknameField.producer, self.viewmodel.whatsUpField.producer, self.viewmodel.profileImageField.producer)
                            .promoteErrors(NSError)
                    }
                    .map { nicknameField, whatsUpField, profileImageField in
                        ProfileEditFormViewController(
                            nickname: (nicknameField?.initialValue, { nicknameField?.onChange($0) }),
                            profileImage: (profileImageField?.initialValue, { profileImageField?.onChange($0) }),
                            whatsUp: (whatsUpField?.initialValue, { whatsUpField?.onChange($0) })
                        )
                    }
                    // dismiss HUD based on the result of update profile signal
                    .on(
                        next: { _ in
                            HUD.dismiss()
                        },
                        failed: { _ in
                            HUD.dismissWithFailedMessage()
                        }
                    )
                    .start { event in
                        switch event {
                        case .Next(let form):
                            self.form = form
                        case .Failed(let error):
                            ProfileLogError(error.description)
                            observer.sendFailed(error)
                        case .Interrupted:
                            observer.sendInterrupted()
                        default: break
                        }
                    }
                

                // Subscribe to disappear notification
                disposable += HUD.didDissappearNotification()
                    .on(next: { _ in ProfileLogVerbose("HUD disappeared.") })
                    .startWithNext { status in

                        // completes the action
                        observer.sendNext(())
                        observer.sendCompleted()
                    }
            }
            s.start()
        }
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "编辑"
        view.backgroundColor = UIColor(red: 0.937, green: 0.937, blue: 0.957, alpha: 1)
        
        let dismissAction = ReactiveCocoa.Action<UIBarButtonItem, Void, NoError> { [weak self]
            button in
            return SignalProducer { observer, disposable in
                self?.dismissViewControllerAnimated(true, completion: nil)
            }
        }
        let dismissButton = UIBarButtonItem(barButtonSystemItem: .Stop, target: dismissAction.unsafeCocoaAction, action: CocoaAction.selector)
        
        
        let submitAction = ReactiveCocoa.Action<UIBarButtonItem, Void, NSError>(
            enabledIf: AnyProperty(
                initialValue: true,
                producer: viewmodel.formValid
            )
        ) { [weak self] button in
            return SignalProducer { observer, disposable in
                if let this = self {
                    
                    // display HUD to indicate work in progress
                    // check for the validity of inputs first
                    disposable += HUD.show()
                        .promoteErrors(NSError)
                        .flatMap(FlattenStrategy.Concat) { _ in this.viewmodel.updateProfile() }
                        // dismiss HUD based on the result of update profile signal
                        .on(
                            next: { _ in
                                HUD.dismissWithNextMessage()
                            },
                            failed: { _ in
                                HUD.dismissWithFailedMessage()
                            }
                        )
                        // does not `sendCompleted` because completion is handled when HUD is disappeared
                        .start { event in
                            switch event {
                            case .Failed(let error):
                                ProfileLogError(error.description)
                                observer.sendFailed(error)
                            case .Interrupted:
                                observer.sendInterrupted()
                            default: break
                            }
                    }
                    
                    // Subscribe to disappear notification
                    disposable += HUD.didDissappearNotification()
                        .on(next: { _ in ProfileLogVerbose("HUD disappeared.") })
                        .startWithNext { status in
                            
                            self?.dismissViewControllerAnimated(true, completion: nil)
                            
                            // completes the action
                            observer.sendNext(())
                            observer.sendCompleted()
                    }
                }
            }
        }
        

        let saveButton = UIBarButtonItem(title: "递交", style: .Done, target: submitAction.unsafeCocoaAction, action: CocoaAction.selector)
        
        let navBar = navigationController?.navigationBar
        navBar?.barTintColor = UIColor.x_PrimaryColor()
        navBar?.tintColor = UIColor.whiteColor()
//        navBar.delegate = self
//        navBar?.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]
        
//        let navigationItem = UINavigationItem()

        // Create two buttons for the navigation item
        navigationItem.leftBarButtonItem = dismissButton
        navigationItem.rightBarButtonItem = saveButton

        // Assign the navigation item to the navigation bar
//        navBar?.items = [navigationItem]
//
//        view.addSubview(navBar)
//        
//        constrain(navBar) {
//            $0.leading == $0.superview!.leading
//            $0.top == $0.superview!.top
//            $0.trailing == $0.superview!.trailing
//            $0.height == 64
//        }
    }
    
    public override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        viewmodel.formValid
            .filter { !$0 }
            .flatMap(FlattenStrategy.Concat) { _ in self.viewmodel.formFormattedErrors }
            .startWithNext {
                Whisper(Message(title: "请修正以下错误\n\($0)", textColor: .whiteColor(), backgroundColor: .redColor()), to: self.navigationController!)
            }
    }
    
    public func bindToViewModel(viewmodel: ProfileEditViewModel) {
        self.viewmodel = viewmodel
    }
}
