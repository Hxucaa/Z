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

public class SignUpView : UIView {
    
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
    
    public weak var delegate: SignUpViewDelegate?
    
    public override func awakeFromNib() {
        setupDismissViewButton()
        setupNicknameField()
        setupBirthdayPicker()
        setupSubtmitButton()
        setupImagePickerButton()
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
            self.delegate?.presentUIImagePickerController()
        }
    }
    
    private func setupNicknameField() {
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
        
        submitButtonSignal! ~> { [unowned self] _ in self.delegate?.submitUpdate(nickname: nicknameField.text, birthday: birthdayPicker.date) }
        
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