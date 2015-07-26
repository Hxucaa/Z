//
//  BusinessCell.swift
//  XListing
//
//  Created by Anson on 2015-07-21.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import UIKit
import ReactiveCocoa

class ProfileBusinessCell: UITableViewCell {


    
    @IBOutlet weak var businessImageView: UIImageView!
    @IBOutlet weak var businessNameLabel: UILabel!

    @IBOutlet weak var popularityLabel: UILabel!
    
    @IBOutlet weak var cityLabel: UILabel!
    
    @IBOutlet weak var distanceLabel: UILabel!
    
    var viewModel: ProfileBusinessViewModel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectionStyle = UITableViewCellSelectionStyle.None
        
        layoutMargins = UIEdgeInsetsZero
        preservesSuperviewLayoutMargins = false
    
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func bindViewModel(viewmodel: ProfileBusinessViewModel) {
        self.viewModel = viewmodel
        businessNameLabel.rac_text <~ viewmodel.businessName
        cityLabel.rac_text <~ viewmodel.city
        popularityLabel.rac_text <~ viewmodel.participation
        distanceLabel.rac_text <~ viewmodel.eta
        
        self.viewModel.coverImage.producer
            |> ignoreNil
            |> start (next: { [weak self] in
                self?.businessImageView.setImageWithAnimation($0)
                })
    }

}
