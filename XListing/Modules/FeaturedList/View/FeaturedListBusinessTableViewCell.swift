//
//  FeaturedListBusinessTableViewCell.swift
//  XListing
//
//  Created by Lance Zhu on 2015-06-20.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import UIKit
import ReactiveCocoa

public final class FeaturedListBusinessTableViewCell : UITableViewCell {
    
    // MARK: - UI Controls
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var businessNameLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var participationLabel: UILabel!
    @IBOutlet weak var etaLabel: UILabel!
    
    // MARK: Properties
    
    private var viewmodel: FeaturedBusinessViewModel!
    
    // MARK: Setups
    
    public override func awakeFromNib() {
        selectionStyle = UITableViewCellSelectionStyle.None
        
        layoutMargins = UIEdgeInsetsZero
        preservesSuperviewLayoutMargins = false
    }
    
    // MARK: Bindings
    
    public func bindViewModel(viewmodel: FeaturedBusinessViewModel) {
        self.viewmodel = viewmodel
        
        businessNameLabel.rac_text <~ viewmodel.businessName
        cityLabel.rac_text <~ viewmodel.city
        participationLabel.rac_text <~ viewmodel.participation
        etaLabel.rac_text <~ viewmodel.eta
        
        self.viewmodel.coverImage.producer
            |> takeUntil(
                rac_prepareForReuseSignal.toSignalProducer()
                    |> toNihil
            )
            |> ignoreNil
            |> start (next: { [weak self] in
                self?.coverImageView.setImageWithAnimation($0)
            })
    }
}