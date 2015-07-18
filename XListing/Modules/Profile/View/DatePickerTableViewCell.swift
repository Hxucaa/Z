//
//  DatePickerTableViewCell.swift
//  XListing
//
//  Created by Bruce Li on 2015-07-18.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import UIKit

public final class DatePickerTableViewCell: UITableViewCell {
    @IBOutlet weak var datePicker: UIDatePicker!

    public override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    public override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
