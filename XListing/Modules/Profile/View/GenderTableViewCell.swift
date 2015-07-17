//
//  GenderTableViewCell.swift
//  XListing
//
//  Created by Bruce Li on 2015-07-16.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import UIKit

public final class GenderTableViewCell: UITableViewCell {

    @IBOutlet weak var genderIcon: UILabel!
    @IBOutlet weak var genderButton: UIButton!
    @IBOutlet weak var editProfilePicButton: UIButton!
    public override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    public override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    

}
