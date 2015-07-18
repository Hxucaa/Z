//
//  NearbyCollectionViewCell.swift
//  XListing
//
//  Created by Lance Zhu on 2015-06-23.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import ReactiveCocoa
import UIKit

public final class NearbyCollectionViewCell : UICollectionViewCell {
    
    // MARK: - UI
    // MARK: Controls
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var businessNameLabel: UILabel!
    @IBOutlet weak var businessHoursLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var etaLabel: UILabel!
    
    private var viewmodel: NearbyTableCellViewModel!
    
    // MARK: Setups
    public override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    public func bindToViewModel(viewmodel: NearbyTableCellViewModel) {
        self.viewmodel = viewmodel
        
        businessNameLabel.rac_text <~ self.viewmodel.businessName
        cityLabel.rac_text <~ self.viewmodel.city
        businessHoursLabel.rac_text <~ self.viewmodel.participation
        etaLabel.rac_text <~ self.viewmodel.eta
        
        self.viewmodel.coverImage.producer
            |> ignoreNil
            |> start (next: { [weak self] in
                self?.coverImageView.setImageWithAnimation($0)
            })
    }
    
    
}
