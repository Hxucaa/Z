//
//  UserCell.swift
//  XListing
//
//  Created by Anson on 2015-09-02.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import UIKit

public final class UserCell: UITableViewCell {
    
    // MARK: - UI Controls
    @IBOutlet private weak var avatarImage: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var ageGroupView: UIView!
    @IBOutlet private weak var constellationLabel: UILabel!
    @IBOutlet private weak var messageLabel: UILabel!
    @IBOutlet private weak var typeLabel: UILabel!

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
