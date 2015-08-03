//
//  GenderTableViewCell.swift
//  XListing
//
//  Created by Bruce Li on 2015-07-16.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import UIKit
import ReactiveCocoa

protocol GenderCellTableViewCellDelegate : class {
    //func setUpGenderPopover(textField: UITextField)
    func editPictureTextButtonAction()
    func presentGenderPopover()
}

public final class GenderTableViewCell: UITableViewCell {

    @IBOutlet private weak var genderIcon: UILabel!
    @IBOutlet private weak var textField: UITextField!
    @IBOutlet private weak var editProfilePicButton: UIButton!
    internal weak var delegate: GenderCellTableViewCellDelegate!
    public var popGenderPicker : GenderPicker?
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        textField.placeholder = "性别"
        genderIcon.text = Icons.Gender.rawValue
        textField.delegate = self

    }

    public override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
        if (popGenderPicker == nil) {
            popGenderPicker = GenderPicker(forTextField: textField)
        }
    }
    
    public func setUpEditProfileButton () {
        let editProfilePicAction = Action<UIButton, Bool, NSError> { [weak self] button in
            self?.delegate.editPictureTextButtonAction()
            return SignalProducer { [weak self] sink, disposible in
                sendCompleted(sink)
            }
        }
        editProfilePicButton.addTarget(editProfilePicAction.unsafeCocoaAction, action: CocoaAction.selector, forControlEvents: .TouchUpInside)
    }
    
    public func getTextfieldText () -> String{
        return textField.text
    }
    
    public func setTextfieldText (text: String) {
        textField.text = text
    }
}

extension GenderTableViewCell: UITextFieldDelegate {
    public func textFieldShouldReturn(textField: UITextField) -> Bool {
        endEditing(true)
        return false
    }
    
    public func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        delegate.presentGenderPopover()
        return false
    }
}
