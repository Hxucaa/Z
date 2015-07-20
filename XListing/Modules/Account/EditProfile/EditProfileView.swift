//
//  SignUpView.swift
//  XListing
//
//  Created by Lance on 2015-05-25.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import UIKit
import ReactiveCocoa
import SVProgressHUD

public final class EditProfileView : UIView, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: - UI
    // MARK: Controls
    @IBOutlet weak var nicknameField: UITextField!
    @IBOutlet weak var imagePickerButton: UIButton!
    @IBOutlet weak var birthdayPicker: UIDatePicker!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var maleButton: UIButton!
    @IBOutlet weak var femaleButton: UIButton!
    private var imagePicker = UIImagePickerController()
    
    // MARK: - Delegate
    public weak var delegate: EditProfileViewDelegate?
    
    // MARK: - Properties
    private var viewmodel: EditProfileViewModel!
    
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
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .PhotoLibrary
    }
    
    private func setupImagePickerButton() {
        /// Action to an UI event
        let presentUIImagePicker = Action<UIButton, Void, NoError> { [weak self] button in
            return SignalProducer { sink, disposable in
                if let imagePicker = self?.imagePicker {
                    self?.delegate?.presentUIImagePickerController(imagePicker)
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
        let submitButtonAction = Action<UIButton, Bool, NSError> { button in
            return SignalProducer { sink, disposable in
                
                // Subscribe to disappear notification
                let didDisappearDisposable = HUD.didDissappearNotification()
                    |> on(next: { _ in AccountLogVerbose("HUD disappeared.") })
                    |> start(next: { [weak self] status in
                        // transition out of this page
                        self?.delegate?.editProfileViewFinished()
                        
                        // completes the action
                        sendNext(sink, true)
                        sendCompleted(sink)
                    })
                
                // Subscribe to touch down inside event
                let touchDownInsideDisposable = HUD.didTouchDownInsideNotification()
                    |> on(next: { _ in AccountLogVerbose("HUD touch down inside.") })
                    |> start(
                        next: { _ in
                            // dismiss HUD
                            HUD.dismiss()
                            
                            // interrupts the action
                            sendInterrupted(sink)
                        }
                    )
                
                // Update profile and show the HUD
                let hudAndUpdate = HUD.show()
                    |> promoteErrors(NSError)
                    |> then(self.viewmodel.updateProfile)
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
                
                // Add the signals to CompositeDisposable for automatic memory management
                disposable.addDisposable(didDisappearDisposable)
                disposable.addDisposable(touchDownInsideDisposable)
                disposable.addDisposable(hudAndUpdate)
            }
        }
        
        submitButton.addTarget(submitButtonAction.unsafeCocoaAction, action: CocoaAction.selector, forControlEvents: .TouchUpInside)
    }
    
    // MARK: Bindings
    
    /**
    Bind viewmodel to view.
    
    :param: viewmodel The viewmodel
    */
    public func bindToViewModel(viewmodel: EditProfileViewModel) {
        self.viewmodel = viewmodel
        
        // Button enabled react to validity of all inputs
        submitButton.rac_enabled <~ self.viewmodel.allInputsValid
        // React to date change
        self.viewmodel.birthday <~ birthdayPicker.rac_date
        // React to text change
        self.viewmodel.nickname <~ nicknameField.rac_text
        
        // Limit the choices on date picker
        self.viewmodel.年龄上限.producer
            |> start(next: { [weak self] in self?.birthdayPicker.maximumDate = $0 })
        self.viewmodel.年龄下限.producer
            |> start(next: { [weak self] in self?.birthdayPicker.minimumDate = $0 })
        
        bindToImageSelectedSignal()
    }
    
    /**
    Bind to image selected signal from `UIImagePickerControllerDelegate`.
    */
    private func bindToImageSelectedSignal() {
        // Subscribe to image picker, the signal sends the dictionary with info for the selected image
        imagePicker.rac_imageSelectedSignal().toSignalProducer()
            // map to the edited image
            |> map { ($0 as! [NSObject : AnyObject])[UIImagePickerControllerEditedImage] as? UIImage }
            |> start(
                // when an image is selected
                next: { [weak self] image in
                    self?.viewmodel.profileImage.put(image)
                    self?.delegate?.dismissUIImagePickerController(nil)
                },
                // when cancel button is pressed
                completed: { [weak self] in
                    // after dismissing the controller, has to rebind the signal because cancellation caused the signal to stop
                    self?.delegate?.dismissUIImagePickerController({ self?.bindToImageSelectedSignal() })
                }
        )
    }
}

extension EditProfileView : UITextFieldDelegate {
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