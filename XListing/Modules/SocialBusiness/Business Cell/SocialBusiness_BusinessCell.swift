//
//  SocialBusiness_BusinessCell.swift
//  XListing
//
//  Created by Anson on 2015-09-02.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import UIKit

public final class SocialBusiness_BusinessCell: UITableViewCell {
    
    // MARK: - UI Controls
    @IBOutlet private weak var coverImageView: UIImageView!
    @IBOutlet private weak var businessNameLabel: UILabel!
    @IBOutlet private weak var dishtypeLabel: UILabel!
    @IBOutlet private weak var locationLabel: UILabel!

    // MARK: - Setups
    public override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    public override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
