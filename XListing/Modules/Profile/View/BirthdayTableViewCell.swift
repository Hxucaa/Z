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
}

public final class BirthdayTableViewCell: UITableViewCell {

    @IBOutlet weak var birthdayTextField: UITextField!
    internal weak var delegate: BirthdayCellTableViewCellDelegate!
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    public override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.delegate.setUpBirthdayPopover(birthdayTextField)
        // Configure the view for the selected state
    }

}
