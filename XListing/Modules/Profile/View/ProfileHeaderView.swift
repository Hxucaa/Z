//
//  ProfileHeaderView.swift
//  XListing
//
//  Created by Anson on 2015-07-21.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import UIKit

class ProfileHeaderView: UIView {
    @IBOutlet weak var topRightButton: UIButton!
    @IBOutlet weak var topLeftButton: UIButton!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var constellationLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    func setup(){
        topLeftButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
    }

}
