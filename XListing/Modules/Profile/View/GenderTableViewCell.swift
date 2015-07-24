//
//  GenderTableViewCell.swift
//  XListing
//
//  Created by Bruce Li on 2015-07-16.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import UIKit

protocol GenderCellTableViewCellDelegate : class {
    
    func setUpGenderPopover(textField: UITextField)
}

public final class GenderTableViewCell: UITableViewCell {

    @IBOutlet weak var genderIcon: UILabel!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var editProfilePicButton: UIButton!
    internal weak var delegate: GenderCellTableViewCellDelegate!
    public override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    public override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.delegate.setUpGenderPopover(textField)
        // Configure the view for the selected state
    }
    
    

}
