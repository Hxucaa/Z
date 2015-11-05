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
    @IBOutlet private weak var coverImageView: UIImageView!
    @IBOutlet private weak var businessNameLabel: UILabel!
    @IBOutlet private weak var businessHoursLabel: UILabel!
    @IBOutlet private weak var cityLabel: UILabel!
    @IBOutlet private weak var etaLabel: UILabel!
    
    // MARK: Properties
    
    private var viewmodel: NearbyTableCellViewModel!
    private let compositeDisposable = CompositeDisposable()
    
    // MARK: Setups
    public override func awakeFromNib() {
        super.awakeFromNib()
        
        coverImageView.layer.masksToBounds = true
        businessNameLabel.layer.masksToBounds = true
        businessHoursLabel.layer.masksToBounds = true
        cityLabel.layer.masksToBounds = true
        etaLabel.layer.masksToBounds = true
    }
    
    deinit {
        compositeDisposable.dispose()
    }
    
    // MARK: Bindings
    public func bindToViewModel(viewmodel: NearbyTableCellViewModel) {
        self.viewmodel = viewmodel
        
        businessNameLabel.rac_text <~ self.viewmodel.businessName.producer
            .takeUntilPrepareForReuse(self)
        
        cityLabel.rac_text <~ self.viewmodel.city.producer
            .takeUntilPrepareForReuse(self)
        
        businessHoursLabel.rac_text <~ self.viewmodel.participation.producer
            .takeUntilPrepareForReuse(self)
        
        etaLabel.rac_text <~ self.viewmodel.eta.producer
            .takeUntilPrepareForReuse(self)
        
        compositeDisposable += self.viewmodel.coverImage.producer
            .takeUntilPrepareForReuse(self)
            .ignoreNil()
            .startWithNext { [weak self] in
                self?.coverImageView.setImageWithAnimation($0)
            }
    }
}
