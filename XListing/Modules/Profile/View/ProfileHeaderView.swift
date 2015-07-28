//
//  ProfileHeaderView.swift
//  XListing
//
//  Created by Anson on 2015-07-21.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import UIKit
import ReactiveCocoa

class ProfileHeaderView: UIView {
    @IBOutlet weak var topRightButton: UIButton!
    @IBOutlet weak var topLeftButton: UIButton!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var constellationLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    
    var viewModel: ProfileHeaderViewModel?
    
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        topLeftButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
    }
    
  
    func bindViewModel(viewmodel: ProfileHeaderViewModel) {
            self.viewModel = viewmodel
            nameLabel.rac_text <~ viewmodel.name
            constellationLabel.rac_text <~ viewmodel.horoscope
            ageLabel.rac_text <~ viewmodel.ageGroup
            locationLabel.rac_text <~ viewmodel.district
            
            self.viewModel!.coverImage.producer
                |> ignoreNil
                |> start (next: { [weak self] in
                    self?.profileImageView.setImageWithAnimation($0)
                    })
    }

}
