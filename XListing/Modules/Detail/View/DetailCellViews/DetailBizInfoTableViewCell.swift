//
//  DetailBizInfoTableViewCell.swift
//  XListing
//
//  Created by Bruce Li on 2015-05-31.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import UIKit

public final class DetailBizInfoTableViewCell: UITableViewCell {

    @IBOutlet weak var businessNameLabel: UILabel!
    @IBOutlet weak var cityAndDistanceLabel: UILabel!
    @IBOutlet weak var participateButton: UIButton!
    internal weak var delegate: DetailBizInfoCellDelegate!
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        participateButton.addTarget(delegate, action: "participate", forControlEvents: UIControlEvents.TouchUpInside)
        // Initialization code
    }

    public override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
