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

public final class EditProfileView : UIView {
    
    // MARK: - UI
    // MARK: Controls
    @IBOutlet weak var dismissViewButton: UIButton!
    @IBOutlet weak var nicknameField: UITextField!
    @IBOutlet weak var imagePickerButton: UIButton!
    @IBOutlet weak var birthdayPicker: UIDatePicker!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var maleButton: UIButton!
    @IBOutlet weak var femaleButton: UIButton!
    
    // MARK: - Delegate
    public weak var delegate: EditProfileViewDelegate?
    
    // MARK: - Private variables
    private let imagePicker = UIImagePickerController()
    private var viewmodel: EditProfileViewModel!
    
    // MARK: - Setup Code
    public override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    /**
    Bind viewmodel to view.
    
    :param: viewmodel The viewmodel
    */
    public func bindToViewModel(viewmodel: EditProfileViewModel) {
        self.viewmodel = viewmodel
        
        setupGenderButtons()
        setupImagePicker()
        setupDismissViewButton()
        setupNicknameField()
        setupBirthdayPicker()
        setupSubmitButton()
        setupImagePickerButton()
    }
    
    private func setupImagePicker() {
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .PhotoLibrary
    }
    
    private func setupDismissViewButton() {
        // Action to an UI event
        let dismissView = Action<UIButton, Void, NoError> { [unowned self] button in
            return SignalProducer { sink, disposable in
                self.delegate?.dismissSignUpView(nil)
            }
        }
        
        dismissViewButton.addTarget(dismissView.unsafeCocoaAction, action: CocoaAction.selector, forControlEvents: .TouchUpInside)
    }
    
    private func setupImagePickerButton() {
        /// Action to an UI event
        let presentUIImagePicker = Action<UIButton, Void, NoError> { [unowned self] button in
            return SignalProducer { sink, disposable in
                self.delegate?.presentUIImagePickerController(self.imagePicker)
                sendCompleted(sink)
            }
        }
        // Link UIControl event to actions
        imagePickerButton.addTarget(presentUIImagePicker.unsafeCocoaAction, action: CocoaAction.selector, forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    private func setupNicknameField() {
        nicknameField.delegate = self
        // React to text change
        viewmodel.nickname <~ nicknameField.rac_text
    }
    
    private func setupGenderButtons() {
        
        self.maleButton.setTitleColor(UIColor.grayColor(), forState: .Normal)
        self.maleButton.setTitleColor(UIColor.blueColor(), forState: .Selected)
        self.femaleButton.setTitleColor(UIColor.grayColor(), forState: .Normal)
        self.femaleButton.setTitleColor(UIColor.blueColor(), forState: .Selected)
        
        
        
        let maleAction = Action<UIButton, Void, NoError> { [unowned self] button in
            
            self.maleButton.selected = true
            self.femaleButton.selected = false
            self.viewmodel.gender.put(Gender.Male)
            return SignalProducer { [unowned self] sink, disposible in
                sendCompleted(sink)
            }
        }
        
        let femaleAction = Action<UIButton, Void, NoError> { [unowned self] button in
            self.femaleButton.selected = true
            self.maleButton.selected = false
            self.viewmodel.gender.put(Gender.Female)
            return SignalProducer { [unowned self] sink, disposible in
                sendCompleted(sink)
            }
        }
        
        // Link UIControl event to actions
        maleButton.addTarget(maleAction.unsafeCocoaAction, action: CocoaAction.selector, forControlEvents: UIControlEvents.TouchUpInside)
        femaleButton.addTarget(femaleAction.unsafeCocoaAction, action: CocoaAction.selector, forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    private func setupBirthdayPicker() {
        // React to date change
        viewmodel.birthday <~ birthdayPicker.rac_date
        
        // Limit the choices on date picker
        let ageLimit = viewmodel.ageLimit
        birthdayPicker.minimumDate = ageLimit.floor
        birthdayPicker.maximumDate = ageLimit.ceil
    }
    
    private func setupSubmitButton() {
        // Button enabled react to validity of all inputs
        submitButton.rac_enabled <~ viewmodel.allInputsValid.producer
        
        // Button action
        let submitAction = Action<UIButton, Bool, NSError> { [unowned self] button in
            let updateProfileAndHUD = HUD.show()
                |> mapError { _ in NSError() }
                |> then(self.viewmodel.updateProfile)
                // dismiss HUD based on the result of update profile signal
                |> HUD.onDismissWithStatusMessage(errorHandler: { error -> String in
                    AccountLogError(error.description)
                    return error.customErrorDescription
                })
            
            let HUDDisappear = HUD.didDissappearNotification() |> mapError { _ in NSError() }
            
            // combine the latest signal of update profile and hud dissappear notification
            // once update profile is done properly and HUD is disappeared, proceed to next step
            return combineLatest(updateProfileAndHUD, HUDDisappear)
                |> map { success, notificationMessage -> Bool in
                    self.viewmodel.dismissAccountView()
                    return success
            }
        }
        
        submitButton.addTarget(submitAction.unsafeCocoaAction, action: CocoaAction.selector, forControlEvents: .TouchUpInside)
    }
}

extension EditProfileView : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    /**
    Tells the delegate that the user picked a still image or movie.
    
    :param: picker The controller object managing the image picker interface.
    :param: info   A dictionary containing the original image and the edited image, if an image was picked; or a filesystem URL for the movie, if a movie was picked. The dictionary also contains any relevant editing information. The keys for this dictionary are listed in Editing Information Keys.
    */
    public func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            viewmodel.profileImage <~ MutableProperty<UIImage?>(pickedImage)
        }
        self.delegate?.dismissSignUpView(nil)
    }
    
    /**
    Tells the delegate that the user cancelled the pick operation.
    
    :param: picker The controller object managing the image picker interface.
    */
    public func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.delegate?.dismissSignUpView(nil)
    }
}

extension EditProfileView : UITextFieldDelegate {
    /**
    The text field calls this method whenever the user taps the return button. You can use this method to implement any custom behavior when the button is tapped.
    
    :param: textField The text field whose return button was pressed.
    
    :returns: YES if the text field should implement its default behavior for the return button; otherwise, NO.
    */
    public func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.endEditing(true)
        return false
    }
}