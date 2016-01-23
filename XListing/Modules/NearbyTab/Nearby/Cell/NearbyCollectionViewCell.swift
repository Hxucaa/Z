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
import XAssets

public final class NearbyCollectionViewCell : UICollectionViewCell {
    
    // MARK: - UI
    // MARK: Controls
    @IBOutlet private weak var coverImageView: UIImageView!
    @IBOutlet private weak var businessNameLabel: UILabel!
    @IBOutlet private weak var businessHoursLabel: UILabel!
    @IBOutlet private weak var cityLabel: UILabel!
    @IBOutlet private weak var etaIcon: UIImageView!
    @IBOutlet private weak var etaLabel: UILabel!
    
    // MARK: Properties
    
    private var viewmodel: NearbyTableCellViewModel!
    private let compositeDisposable = CompositeDisposable()
    
    // MARK: Setups
    public override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = .x_FeaturedCardBG()
        
        coverImageView.layer.masksToBounds = true
        coverImageView.backgroundColor = .x_FeaturedCardBG()
        businessNameLabel.layer.masksToBounds = true
        businessNameLabel.backgroundColor = .x_FeaturedCardBG()
        businessHoursLabel.layer.masksToBounds = true
        businessHoursLabel.backgroundColor = .x_FeaturedCardBG()
        cityLabel.layer.masksToBounds = true
        cityLabel.backgroundColor = .x_FeaturedCardBG()
        etaLabel.layer.masksToBounds = true
        etaLabel.backgroundColor = .x_FeaturedCardBG()
        
        
        // Adding ETA icon
        etaIcon.rac_image <~ AssetFactory.getImage(Asset.CarIcon(size: etaIcon.frame.size, backgroundColor: .x_FeaturedCardBG(), opaque: nil, imageContextScale: nil, pressed: false, shadow: false))
            .take(1)
            .map { Optional<UIImage>($0) }
    }
    
    deinit {
        compositeDisposable.dispose()
    }
    
    // MARK: Bindings
    public func bindToViewModel(viewmodel: NearbyTableCellViewModel) {
        self.viewmodel = viewmodel
        
        self.viewmodel.fetchCoverImage()
            .start()
        
        businessNameLabel.rac_text <~ self.viewmodel.name.producer
            .takeUntilPrepareForReuse(self)
        
        cityLabel.rac_text <~ self.viewmodel.city.producer
            .takeUntilPrepareForReuse(self)
        
        businessHoursLabel.rac_text <~ self.viewmodel.participation.producer
            .takeUntilPrepareForReuse(self)
        
        etaLabel.rac_text <~ self.viewmodel.eta.producer
            .takeUntilPrepareForReuse(self)
            .ignoreNil()
        
        compositeDisposable += self.viewmodel.coverImage.producer
            .takeUntilPrepareForReuse(self)
            .startWithNext { [weak self] in
                self?.coverImageView.setImageWithAnimation($0)
            }
    }
}
