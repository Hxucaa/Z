//
//  DetailAddressTableViewCell.swift
//  XListing
//
//  Created by Bruce Li on 2015-06-01.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import UIKit

public final class DetailAddressTableViewCell: UITableViewCell {

    @IBOutlet weak var addressButton: UIButton!
    internal weak var delegate: DetailAddressCellDelegate!
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        addressButton.addTarget(delegate, action: "goToMapVC", forControlEvents: UIControlEvents.TouchUpInside)
    }

    public override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
