//
//  PhoneEmailTableViewCell.swift
//  XListing
//
//  Created by Bruce Li on 2015-07-19.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import UIKit

public final class PhoneEmailTableViewCell: UITableViewCell {

    @IBOutlet weak var icon: UILabel!
    @IBOutlet weak var textField: UITextField!
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    public override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    public func initialize(type: String) {
        if type == "Phone" {
            self.textField.keyboardType = UIKeyboardType.NumbersAndPunctuation
            self.icon.text = Icons.Phone.rawValue
            self.textField.placeholder = "电话"
        } else if type == "Email" {
            self.textField.keyboardType = UIKeyboardType.EmailAddress
            self.icon.text = Icons.Email.rawValue
            self.textField.placeholder = "邮件"
        }
    }

}