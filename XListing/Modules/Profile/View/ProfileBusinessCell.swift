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

public final class ProfileBusinessCell: UITableViewCell {
    
    // MARK: - UI Controls
    @IBOutlet private weak var businessImageView: UIImageView!
    @IBOutlet private weak var businessNameLabel: UILabel!
    @IBOutlet private weak var popularityLabel: UILabel!
    @IBOutlet private weak var cityLabel: UILabel!
    @IBOutlet private weak var distanceLabel: UILabel!
    
    
    // MARK: - Properties
    private var viewModel: ProfileBusinessViewModel!
    
    
    // MARK: - Setups
    public override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = UITableViewCellSelectionStyle.None
        layoutMargins = UIEdgeInsetsZero
        preservesSuperviewLayoutMargins = false
    
    }
    
    // MARK: - Bindings
    public func bindViewModel(viewmodel: ProfileBusinessViewModel) {
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
