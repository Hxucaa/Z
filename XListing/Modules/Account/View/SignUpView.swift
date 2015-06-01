//
//  SignUpView.swift
//  XListing
//
//  Created by Lance on 2015-05-25.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import UIKit
import ReactKit

public final class SignUpView : UIView {
    
    private let imagePicker = UIImagePickerController()
    
    @IBOutlet weak var dismissViewButton: UIButton!
    @IBOutlet weak var nicknameField: UITextField!
    @IBOutlet weak var imagePickerButton: UIButton!
    @IBOutlet weak var birthdayPicker: UIDatePicker!
    @IBOutlet weak var submitButton: UIButton!
    
    private var dismissViewButtonSignal: Stream<NSString?>?
    public var nicknameFieldSignal: Stream<NSString?>?
    public var birthdayPickerSignal: Stream<NSDate?>?
    public var submitButtonSignal: Stream<NSString?>?
    private var imagePickerButtonSignal: Stream<NSString?>?
    
    // Profile imaged picked by user
    private var profileImage: UIImage?
    
    public weak var delegate: SignUpViewDelegate?
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        
        setupImagePicker()
        setupDismissViewButton()
        setupNicknameField()
        setupBirthdayPicker()
        setupSubtmitButton()
        setupImagePickerButton()
    }
    
    private func setupImagePicker() {
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .PhotoLibrary
    }
    
    private func setupDismissViewButton() {
        // React to button press
        dismissViewButtonSignal = dismissViewButton.buttonStream("Dismiss View Button")
        
        dismissViewButtonSignal! ~> { [unowned self] _ in
            self.delegate?.dismissViewController()
        }
    }
    
    private func setupImagePickerButton() {
        // React to button press
        imagePickerButtonSignal = imagePickerButton.buttonStream("Image Picker Button")
        
        imagePickerButtonSignal! ~> { [unowned self] _ in
            self.delegate?.presentUIImagePickerController(self.imagePicker)
        }
    }
    
    private func setupNicknameField() {
        nicknameField.delegate = self
        // React to text change
        nicknameFieldSignal = nicknameField.textChangedStream()
    }
    
    private func setupBirthdayPicker() {
        // React to date change
        birthdayPickerSignal = birthdayPicker.dateChangedStream()
    }
    
    private func setupSubtmitButton() {
        // React to button press
        submitButtonSignal = submitButton.buttonStream("Submit Button")
        
        submitButtonSignal! ~> { [unowned self] _ in self.delegate?.submitUpdate(nickname: nicknameField.text, birthday: birthdayPicker.date, profileImage: profileImage) }
        
        /**
        *   Enable or diable submit button
        */
        // Map text value to boolean
        let nicknameFieldHasValueSignal = nicknameFieldSignal!
            // if text length is greater than 1 return true, otherwise false
            |> map { $0!.length > 0 }
            // starting value as false
            |> startWith(false)
        
        // Map date value to boolean
        let birthdayPickerHasValueSignal = birthdayPickerSignal!
            |> map { _ in true }
            |> startWith(false)
        
        // Combine two signals into one
        let enableSubmitButtonSignal = [nicknameFieldHasValueSignal, birthdayPickerHasValueSignal]
            // merge signals and combine their latest values
            |> merge2All
            |> map { [unowned self] (values, changedValues) -> NSNumber? in
                if let v0 = values[0], v1 = values[1] {
                    return v0 && v1
                }
                return false
            }
        
        // Declare ownership of the signal
        enableSubmitButtonSignal.ownedBy(self)
        
        // Submit Button reacts to the signal to be enabled/disabled
        (submitButton, "enabled") <~ enableSubmitButtonSignal
    }
}

extension SignUpView : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    public func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            profileImage = pickedImage
            
        }
        delegate?.dismissViewController()
    }
    
    public func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        delegate?.dismissViewController()
    }
}

extension SignUpView : UITextFieldDelegate {
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