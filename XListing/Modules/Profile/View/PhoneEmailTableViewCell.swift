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

}
