//
//  DetailPhoneWebTableViewCell.swift
//  XListing
//
//  Created by Bruce Li on 2015-06-01.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import UIKit

public final class DetailPhoneWebTableViewCell: UITableViewCell {

    @IBOutlet weak var phoneButton: UIButton!
    @IBOutlet weak var websiteButton: UIButton!
    internal weak var delegate: DetailPhoneWebCellDelegate!
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        websiteButton.addTarget(delegate, action: "goToWebsite", forControlEvents: UIControlEvents.TouchUpInside)
        phoneButton.addTarget(delegate, action: "callPhone", forControlEvents: UIControlEvents.TouchUpInside)
        // Initialization code
    }

    public override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
