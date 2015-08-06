//
//  NicknameTableViewCell.swift
//  
//
//  Created by Bruce Li on 2015-07-19.
//
//

import UIKit
import ReactiveCocoa

protocol NicknameCellTableViewCellDelegate : class {
    
    func editPictureButtonAction ()
}

public final class NicknameTableViewCell: UITableViewCell {

    @IBOutlet weak var textField: UITextField!
    @IBOutlet private weak var editProfilePicButton: UIButton!
    internal weak var delegate: NicknameCellTableViewCellDelegate!
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        textField.placeholder = "昵称"
        textField.delegate = self
    }

    public override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    public func setUpEditProfileButton () {
        let editProfilePicAction = Action<UIButton, Bool, NSError> { [weak self] button in
            self?.delegate.editPictureButtonAction()
            return SignalProducer { [weak self] sink, disposible in
                sendCompleted(sink)
            }
        }
        editProfilePicButton.addTarget(editProfilePicAction.unsafeCocoaAction, action: CocoaAction.selector, forControlEvents: .TouchUpInside)
    }
    
    public func getTextfield_rac_text () -> MutableProperty<String?> {
        return textField.rac_text
    }
    
    public func setTextfieldText (text: MutableProperty<String?>) {
        textField.text = text.value
    }

}

extension NicknameTableViewCell: UITextFieldDelegate {
    public func textFieldShouldReturn(textField: UITextField) -> Bool {
        endEditing(true)
        return false
    }
}
