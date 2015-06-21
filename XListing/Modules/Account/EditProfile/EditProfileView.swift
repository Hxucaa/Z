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
    
    // MARK: Actions
    private var dismissViewButtonAction: CocoaAction!
    private var submitButtonAction: CocoaAction!
    private var imagePickerButtonAction: CocoaAction!
    private var imagePickerCancelAction: CocoaAction!
    
    // MARK: - Delegate
    public weak var delegate: EditProfileViewDelegate?
    
    // MARK: - Private variables
    private let imagePicker = UIImagePickerController()
    private var viewmodel: EditProfileViewModel!
    private let hud = HUD.sharedInstance
    private var HUDdisposable: Disposable!
    
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
        
        setupHUD()
        setupImagePicker()
        setupDismissViewButton()
        setupNicknameField()
        setupBirthdayPicker()
        setupSubtmitButton()
        setupImagePickerButton()
    }
    
    /**
    Setup HUD
    */
    private func setupHUD() {
        HUDdisposable = hud.didDissappearNotification(
            interrupted: { _ in
            },
            error: { errorMessage in
            },
            completed: { _ in
                // Dismiss view
                self.viewmodel.dismissAccountView() {
                    self.HUDdisposable.dispose()
                }
            }
        )
    }
    
    private func setupImagePicker() {
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .PhotoLibrary
    }
    
    private func setupDismissViewButton() {
        // Action to an UI event
        let dismissView = Action<Void, Void, NoError> {
            return SignalProducer { sink, disposable in
                self.delegate?.dismissSignUpView(nil)
            }
        }
        
        // Bridging
        dismissViewButtonAction = CocoaAction(dismissView, input: ())
        
        dismissViewButton.addTarget(dismissViewButtonAction, action: CocoaAction.selector, forControlEvents: .TouchUpInside)
    }
    
    private func setupImagePickerButton() {
        /// Action to an UI event
        let presentUIImagePicker = Action<Void, Void, NoError> {
            return SignalProducer { sink, disposable in
                self.delegate?.presentUIImagePickerController(self.imagePicker)
                sendCompleted(sink)
            }
        }
        
        // Bridging actions to Objective-C
        imagePickerButtonAction = CocoaAction(presentUIImagePicker, input: ())
        
        // Link UIControl event to actions
        imagePickerButton.addTarget(imagePickerButtonAction, action: CocoaAction.selector, forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    private func setupNicknameField() {
        nicknameField.delegate = self
        // React to text change
        viewmodel.nickname <~ nicknameField.rac_text
    }
    
    private func setupBirthdayPicker() {
        // React to date change
        viewmodel.birthday <~ birthdayPicker.rac_date
        
        // Limit the choices on date picker
        let ageLimit = viewmodel.ageLimit
        birthdayPicker.minimumDate = ageLimit.floor
        birthdayPicker.maximumDate = ageLimit.ceil
    }
    
    private func setupSubtmitButton() {
        // Button enabled react to validity of all inputs
        submitButton.rac_enabled <~ viewmodel.allInputsValid.producer
        
        // Button action
        let action = Action<Void, Bool, NSError> { [unowned self] in
            return self.hud.show()
                |> mapError { _ in NSError() }
                |> flatMap(FlattenStrategy.Merge) { _ in self.viewmodel.updateProfile }
                |> self.hud.onDismiss(errorHandler: { error -> String in
                    return "失败了..."
                })
        }
        
        // Bridging actions to Objective-C
        submitButtonAction = CocoaAction(action, input: ())
        
        submitButton.addTarget(submitButtonAction, action: CocoaAction.selector, forControlEvents: .TouchUpInside)
    }
}

extension EditProfileView : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    /**
    Tells the delegate that the user picked a still image or movie.
    
    :param: picker The controller object managing the image picker interface.
    :param: info   A dictionary containing the original image and the edited image, if an image was picked; or a filesystem URL for the movie, if a movie was picked. The dictionary also contains any relevant editing information. The keys for this dictionary are listed in Editing Information Keys.
    */
    public func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
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