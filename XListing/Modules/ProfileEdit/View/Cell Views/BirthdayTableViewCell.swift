//
//  BirthdayTableViewCell.swift
//  XListing
//
//  Created by Bruce Li on 2015-07-18.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import UIKit
import ReactiveCocoa

protocol BirthdayCellTableViewCellDelegate : class {
    
    func presentBirthdayPopover()
}

public final class BirthdayTableViewCell: UITableViewCell {

    @IBOutlet private weak var textField: UITextField!
    internal weak var delegate: BirthdayCellTableViewCellDelegate!
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        textField.placeholder = "生日"
        textField.delegate = self
    }

    public override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    public func getTextfieldText () -> String{
        return textField.text
    }
    
    public func setTextfieldText (text: String) {
        textField.text = text
    }
}

extension BirthdayTableViewCell: UITextFieldDelegate {
    public func textFieldShouldReturn(textField: UITextField) -> Bool {
        endEditing(true)
        return false
    }
    
    public func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        delegate.presentBirthdayPopover()
        return false
    }
}


