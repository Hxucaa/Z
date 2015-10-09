//
//  ParticipationListViewCell.swift
//  XListing
//
//  Created by Lance Zhu on 2015-10-07.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import UIKit
import ReactiveCocoa
import AVOSCloud
import Dollar
import Cartography

public final class ParticipationListViewCell : UITableViewCell {
    
    // MARK: - UI Controls
    @IBOutlet private weak var businessImageView: UIImageView!
    @IBOutlet private weak var businessNameLabel: UILabel!
    @IBOutlet private weak var popularityLabel: UILabel!
    @IBOutlet private weak var cityLabel: UILabel!
    @IBOutlet private weak var distanceLabel: UILabel!
    
    // MARK: - Properties
    private var viewmodel: IParticipationListCellViewModel!
    
    // MARK: - Initializers
    
    // MARK: - Setups
    public override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = UITableViewCellSelectionStyle.None
        layoutMargins = UIEdgeInsetsZero
        preservesSuperviewLayoutMargins = false
        
    }
    
    // MARK: - Bindings
    
    public func bindToViewModel(viewmodel: IParticipationListCellViewModel) {
        self.viewmodel = viewmodel
        
        businessNameLabel.rac_text <~ viewmodel.businessName
        cityLabel.rac_text <~ viewmodel.city
        popularityLabel.rac_text <~ viewmodel.participation
        distanceLabel.rac_text <~ viewmodel.eta.producer
            |> ignoreNil
        businessImageView.rac_image <~ viewmodel.coverImage
    }
}