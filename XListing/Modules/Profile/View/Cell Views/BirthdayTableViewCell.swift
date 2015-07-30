//
//  BirthdayTableViewCell.swift
//  XListing
//
//  Created by Bruce Li on 2015-07-18.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import UIKit

protocol BirthdayCellTableViewCellDelegate : class {
    
    func setUpBirthdayPopover(textField: UITextField)
    func presentBirthdayPopover()
}

public final class BirthdayTableViewCell: UITableViewCell {

    @IBOutlet weak var birthdayTextField: UITextField!
    internal weak var delegate: BirthdayCellTableViewCellDelegate!
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.birthdayTextField.placeholder = "生日"
        self.birthdayTextField.delegate = self
    }

    public override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
        self.delegate.setUpBirthdayPopover(birthdayTextField)
    }
}

extension BirthdayTableViewCell: UITextFieldDelegate {
    public func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.endEditing(true)
        return false
    }
    
    public func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        self.delegate.presentBirthdayPopover()
        return false
    }
}


