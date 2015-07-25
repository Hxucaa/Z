//
//  EditInfoView.swift
//  XListing
//
//  Created by Lance on 2015-05-25.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import UIKit
import ReactiveCocoa

public final class EditInfoView : UIView {
    
    // MARK: - UI
    // MARK: Controls
    @IBOutlet weak var nicknameField: UITextField!
    @IBOutlet weak var imagePickerButton: UIButton!
    @IBOutlet weak var birthdayPicker: UIDatePicker!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var maleButton: UIButton!
    @IBOutlet weak var femaleButton: UIButton!
    private var imagePicker = UIImagePickerController()
    
    // MARK: - Proxies
    
    /// Present UIImage Picker Controller
    public var presentUIImagePickerProxy: SignalProducer<UIImagePickerController, NoError> {
        return _presentUIImagePickerProxy
    }
    private let (_presentUIImagePickerProxy, _presentUIImagePickerSink) = SignalProducer<UIImagePickerController, NoError>.buffer(1)
    
    /// Dismiss UIImage Picker Controller
    public var dismissUIImagePickerProxy: SignalProducer<CompletionHandler, NoError> {
        return _dismissUIImagePickerProxy
    }
    private let (_dismissUIImagePickerProxy, _dismissUIImagePickerSink) = SignalProducer<CompletionHandler, NoError>.buffer(1)
    
    /// Edit Info view is finished.
    public var finishEditInfoProxy: SignalProducer<Void, NoError> {
        return _finishEditInfoProxy
    }
    private let (_finishEditInfoProxy, _finishEditInfoSink) = SignalProducer<Void, NoError>.buffer(1)
    
    // MARK: - Properties
    private var viewmodel: EditInfoViewModel!
    private let compositeDisposable = CompositeDisposable()
    
    // MARK: - Setups
    public override func awakeFromNib() {
        super.awakeFromNib()
        
        setupGenderButtons()
        setupImagePicker()
        setupNicknameField()
        setupSubmitButton()
        setupImagePickerButton()
    }
    
    private func setupImagePicker() {
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .PhotoLibrary
    }
    
    private func setupImagePickerButton() {
        /// Action to an UI event
        let presentUIImagePicker = Action<UIButton, Void, NoError> { [weak self] button in
            return SignalProducer { sink, disposable in
                if let this = self {
                    sendNext(this._presentUIImagePickerSink, this.imagePicker)
                }
                sendCompleted(sink)
            }
        }
        // Link UIControl event to actions
        imagePickerButton.addTarget(presentUIImagePicker.unsafeCocoaAction, action: CocoaAction.selector, forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    private func setupNicknameField() {
        nicknameField.delegate = self
    }
    
    private func setupGenderButtons() {
        
        maleButton.setTitleColor(UIColor.grayColor(), forState: .Normal)
        maleButton.setTitleColor(UIColor.blueColor(), forState: .Selected)
        femaleButton.setTitleColor(UIColor.grayColor(), forState: .Normal)
        femaleButton.setTitleColor(UIColor.blueColor(), forState: .Selected)
        
        let maleAction = Action<UIButton, Void, NoError> { [weak self] button in
            
            return SignalProducer { sink, disposible in
                self?.maleButton.selected = true
                self?.femaleButton.selected = false
                self?.viewmodel.gender.put(Gender.Male)
                sendCompleted(sink)
            }
        }
        
        let femaleAction = Action<UIButton, Void, NoError> { [weak self] button in
            return SignalProducer { sink, disposible in
                self?.femaleButton.selected = true
                self?.maleButton.selected = false
                self?.viewmodel.gender.put(Gender.Female)
                sendCompleted(sink)
            }
        }
        
        // Link UIControl event to actions
        maleButton.addTarget(maleAction.unsafeCocoaAction, action: CocoaAction.selector, forControlEvents: UIControlEvents.TouchUpInside)
        femaleButton.addTarget(femaleAction.unsafeCocoaAction, action: CocoaAction.selector, forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    private func setupSubmitButton() {
        
        // Button action
        let submitButtonAction = Action<UIButton, Void, NSError> { [weak self] button in
            return SignalProducer { sink, disposable in
                if let this = self {
                    
                    // Update profile and show the HUD
                    disposable += SignalProducer<Void, NoError>.empty
                        // delay the signal due to the animation of retracting keyboard
                        // this cannot be executed on main thread, otherwise UI will be blocked
                        |> delay(Constants.HUD_DELAY, onScheduler: QueueScheduler())
                        // return the signal to main/ui thread in order to run UI related code
                        |> observeOn(UIScheduler())
                        |> then(HUD.show())
                        // map error to the same type as other signal
                        |> promoteErrors(NSError)
                        // update profile
                        |> then(this.viewmodel.updateProfile)
                        // dismiss HUD based on the result of update profile signal
                        |> HUD.dismissWithStatusMessage(errorHandler: { error -> String in
                            AccountLogError(error.description)
                            return error.customErrorDescription
                        })
                        // does not `sendCompleted` because completion is handled when HUD is disappeared
                        |> start(
                            error: { error in
                                sendError(sink, error)
                            },
                            interrupted: { _ in
                                sendInterrupted(sink)
                            }
                    )
                    
                    // Subscribe to touch down inside event
                    disposable += HUD.didTouchDownInsideNotification()
                        |> on(next: { _ in AccountLogVerbose("HUD touch down inside.") })
                        |> start(
                            next: { _ in
                                // dismiss HUD
                                HUD.dismiss()
                            }
                    )
                    
                    // Subscribe to disappear notification
                    disposable += HUD.didDissappearNotification()
                        |> on(next: { _ in AccountLogVerbose("HUD disappeared.") })
                        |> start(next: { status in
                            if status == HUD.DisappearStatus.Normal {
                                sendNext(this._finishEditInfoSink, ())
                            }
                            
                            // completes the action
                            sendNext(sink, ())
                            sendCompleted(sink)
                        })
                    
                    // Add the signals to CompositeDisposable for automatic memory management
                    disposable.addDisposable {
                        AccountLogVerbose("Update profile action is disposed.")
                    }
                    
                    // retract keyboard
                    self?.endEditing(true)
                }
            }
        }
        
        submitButton.addTarget(submitButtonAction.unsafeCocoaAction, action: CocoaAction.selector, forControlEvents: .TouchUpInside)
    }
    
    deinit {
        compositeDisposable.dispose()
        AccountLogVerbose("Edit Info View deinitializes.")
    }
    
    // MARK: Bindings
    
    /**
    Bind viewmodel to view.
    
    :param: viewmodel The viewmodel
    */
    public func bindToViewModel(viewmodel: EditInfoViewModel) {
        self.viewmodel = viewmodel
        
        // Button enabled react to validity of all inputs
        submitButton.rac_enabled <~ self.viewmodel.allInputsValid
        // React to date change
        self.viewmodel.birthday <~ birthdayPicker.rac_date
        // React to text change
        self.viewmodel.nickname <~ nicknameField.rac_text
        
        // Limit the choices on date picker
        compositeDisposable += self.viewmodel.年龄上限.producer
            |> start(next: { [weak self] in self?.birthdayPicker.maximumDate = $0 })
        compositeDisposable += self.viewmodel.年龄下限.producer
            |> start(next: { [weak self] in self?.birthdayPicker.minimumDate = $0 })
        
        bindToImageSelectedSignal()
    }
    
    /**
    Bind to image selected signal from `UIImagePickerControllerDelegate`.
    */
    private func bindToImageSelectedSignal() {
        // Subscribe to image picker, the signal sends the dictionary with info for the selected image
        compositeDisposable += imagePicker.rac_imageSelectedSignal().toSignalProducer()
            // map to the edited image
            |> map { ($0 as! [NSObject : AnyObject])[UIImagePickerControllerEditedImage] as? UIImage }
            |> start(
                // when an image is selected
                next: { [weak self] image in
                    self?.viewmodel.profileImage.put(image)
                    
                    if let this = self {
                        sendNext(this._dismissUIImagePickerSink, { self?.bindToImageSelectedSignal() })
                    }
                },
                // when cancel button is pressed
                completed: { [weak self] in
                    // after dismissing the controller, has to rebind the signal because cancellation caused the signal to stop
                    if let this = self {
                        sendNext(this._dismissUIImagePickerSink, { self?.bindToImageSelectedSignal() })
                    }
                }
        )
    }
}

extension EditInfoView : UITextFieldDelegate {
    /**
    The text field calls this method whenever the user taps the return button. You can use this method to implement any custom behavior when the button is tapped.
    
    :param: textField The text field whose return button was pressed.
    
    :returns: YES if the text field should implement its default behavior for the return button; otherwise, NO.
    */
    public func textFieldShouldReturn(textField: UITextField) -> Bool {
        endEditing(true)
        return false
    }
}