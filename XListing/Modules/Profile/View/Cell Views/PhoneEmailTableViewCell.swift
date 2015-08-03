//
//  PhoneEmailTableViewCell.swift
//  XListing
//
//  Created by Bruce Li on 2015-07-19.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import UIKit

protocol PhoneEmailCellTableViewCellDelegate : class {
    func notifyTextFieldBeginEditing()
}

public final class PhoneEmailTableViewCell: UITableViewCell {

    @IBOutlet private weak var icon: UILabel!
    @IBOutlet private weak var textField: UITextField!
    internal weak var delegate: PhoneEmailCellTableViewCellDelegate!
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        textField.delegate = self
    }

    public override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    public func initialize(type: String) {
        if type == "Phone" {
            textField.keyboardType = UIKeyboardType.NumbersAndPunctuation
            icon.text = Icons.Phone.rawValue
            textField.placeholder = "电话"
        } else if type == "Email" {
            textField.keyboardType = UIKeyboardType.EmailAddress
            icon.text = Icons.Email.rawValue
            textField.placeholder = "邮件"
        }
    }
}

extension PhoneEmailTableViewCell: UITextFieldDelegate {
    public func textFieldShouldReturn(textField: UITextField) -> Bool {
        endEditing(true)
        return false
    }
    
    public func textFieldDidBeginEditing(textField: UITextField) {
        delegate.notifyTextFieldBeginEditing()
    }

}
