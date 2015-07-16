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
        
        setupGenderButtons()
        setupImagePicker()
        setupNicknameField()
        setupSubmitButton()
        setupImagePickerButton()
    }
    
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
        self.viewmodel.nickname <~ nicknameField.rac_optionalText
        
        // Limit the choices on date picker
        self.viewmodel.年龄上限.producer
            |> start(next: { [unowned self] in self.birthdayPicker.maximumDate = $0 })
        self.viewmodel.年龄下限.producer
            |> start(next: { [unowned self] in self.birthdayPicker.minimumDate = $0 })
    }
    
    private func setupImagePicker() {
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .PhotoLibrary
    }
    
    private func setupImagePickerButton() {
        /// Action to an UI event
        let presentUIImagePicker = Action<UIButton, Void, NoError> { [unowned self] button in
            return SignalProducer { [unowned self] sink, disposable in
                self.delegate?.presentUIImagePickerController(self.imagePicker)
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
    
    private func setupSubmitButton() {
        
        // Button action
        let submitAction = Action<UIButton, Bool, NSError> { [unowned self] button in
            let updateProfileAndHUD = HUD.show()
                |> promoteErrors(NSError)
                |> then(self.viewmodel.updateProfile)
                // dismiss HUD based on the result of update profile signal
                |> HUD.onDismissWithStatusMessage(errorHandler: { error -> String in
                    AccountLogError(error.description)
                    return error.customErrorDescription
                })
            
            let HUDDisappear = HUD.didDissappearNotification()
                |> promoteErrors(NSError)
            
            // combine the latest signal of update profile and hud dissappear notification
            // once update profile is done properly and HUD is disappeared, proceed to next step
            return combineLatest(updateProfileAndHUD, HUDDisappear)
                |> map { [unowned self] success, notificationMessage -> Bool in
                    self.delegate?.editProfileViewFinished()
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
        delegate?.dismissUIImagePickerController(nil)
    }
    
    /**
    Tells the delegate that the user cancelled the pick operation.
    
    :param: picker The controller object managing the image picker interface.
    */
    public func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        delegate?.dismissUIImagePickerController(nil)
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