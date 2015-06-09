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
    
    // MARK: - UI
    @IBOutlet weak var dismissViewButton: UIButton!
    @IBOutlet weak var nicknameField: UITextField!
    @IBOutlet weak var imagePickerButton: UIButton!
    @IBOutlet weak var birthdayPicker: UIDatePicker!
    @IBOutlet weak var submitButton: UIButton!
    
    // MARK: - UI Observer Signals
    private var dismissViewButtonSignal: Stream<String?>?
    private var nicknameFieldSignal: Stream<NSString?>?
    private var birthdayPickerSignal: Stream<NSDate?>?
    private var submitButtonSignal: Stream<String?>?
    private var imagePickerButtonSignal: Stream<String?>?
    
    // MARK: - Delegate
    public weak var delegate: SignUpViewDelegate?
    
    // MARK: - Viewmodel
    private var viewmodel: SignUpViewModel!
    
    // MARK: - Setup Code
    public override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    /**
    Bind viewmodel to view.
    
    :param: viewmodel The viewmodel
    */
    public func bindToViewModel(viewmodel: SignUpViewModel) {
        self.viewmodel = viewmodel
        
        setupImagePicker()
        setupDismissViewButton()
        setupNicknameField()
        setupBirthdayPicker()
        setupSubtmitButton()
        setupImagePickerButton()
    }
    
    private func setupImagePicker() {
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .PhotoLibrary
    }
    
    private func setupDismissViewButton() {
        // React to button press
        dismissViewButtonSignal = dismissViewButton.buttonStream("Dismiss View Button")
        
        // Create completion handler for dismissal of view
        let dismissSignal = dismissViewButtonSignal!
            |> flatMap { [unowned self] _ in self.completeSignal() }
        
        dismissSignal.ownedBy(self)
        // Dismiss view
        dismissSignal ~> self.delegate!.dismissSignUpView
    }
    
    private func setupImagePickerButton() {
        // React to button press
        imagePickerButtonSignal = imagePickerButton.buttonStream("Image Picker Button")
        
        // Present image picker controller
        imagePickerButtonSignal! ~> { [unowned self] _ in
            self.delegate?.presentUIImagePickerController(self.imagePicker)
        }
    }
    
    private func setupNicknameField() {
        nicknameField.delegate = self
        // React to text change
        nicknameFieldSignal = nicknameField.textChangedStream()
        
        /// bind nickname field to nickname in viewmodel
        (viewmodel, "nickname") <~ nicknameFieldSignal!
    }
    
    private func setupBirthdayPicker() {
        // React to date change
        birthdayPickerSignal = birthdayPicker.dateChangedStream()
        
        // Limit the choices on date picker
        let ageLimit = viewmodel.ageLimit
        birthdayPicker.minimumDate = ageLimit.floor
        birthdayPicker.maximumDate = ageLimit.ceil
        
        /// bind birthday picker to birthday in viewmodel
        (self.viewmodel, "birthday") <~ birthdayPickerSignal!
    }
    
    private func setupSubtmitButton() {
        submitButton.enabled = false
        // React to button press
        submitButtonSignal = submitButton.buttonStream("Submit Button")
        
        /// bind areInputsValidSignal to submit button's enabled attribute
        let nsnumberSignal = self.viewmodel.allInputsValidSignal
            |> map {
                Optional<NSNumber>(NSNumber(bool: $0!))
            }
        nsnumberSignal.ownedBy(self)
        (submitButton, "enabled") <~ nsnumberSignal

        /// Bind submit button to updateProfile from viewmodel
        let updateProfileSignal = submitButtonSignal!
            // Update profile
            |> flatMap { [unowned self] _ -> Stream<Bool> in
                return self.viewmodel.updateProfile()
            }
            // Create completion handler for dismissal of view
            |> flatMap { [unowned self] success -> Stream<CompletionHandler?> in
                if success {
                    return self.completeSignal()
                }
                else {
                    AccountLogError("Update profile failed.")
                    return Stream<CompletionHandler?>.error(NSError(domain: "Sign up view", code: 899, userInfo: nil))
                }
            }
        updateProfileSignal.ownedBy(self)
        // Dismiss view
        updateProfileSignal ~> self.delegate!.dismissSignUpView
    }
    
    /**
    Create a signal which contains the completion handler.
    
    :param: completion CompletionHandler? The callback handler.
    
    :returns: A signal which contains the completion handler.
    */
    private func completeSignal(completion: CompletionHandler? = nil) -> Stream<CompletionHandler?> {
        return Stream<CompletionHandler?>.just(completion)
    }
}

extension SignUpView : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    /**
    Tells the delegate that the user picked a still image or movie.
    
    :param: picker The controller object managing the image picker interface.
    :param: info   A dictionary containing the original image and the edited image, if an image was picked; or a filesystem URL for the movie, if a movie was picked. The dictionary also contains any relevant editing information. The keys for this dictionary are listed in Editing Information Keys.
    */
    public func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            (viewmodel, "profileImage") <~ Stream<UIImage?>.just(pickedImage)
        }
        self.completeSignal() ~> delegate!.dismissSignUpView
    }
    
    /**
    Tells the delegate that the user cancelled the pick operation.
    
    :param: picker The controller object managing the image picker interface.
    */
    public func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.completeSignal() ~> delegate!.dismissSignUpView
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