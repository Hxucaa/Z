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
    }
    
    deinit {
        compositeDisposable.dispose()
    }
    
    // MARK: Bindings
    public func bindToViewModel(viewmodel: NearbyTableCellViewModel) {
        self.viewmodel = viewmodel
        
        businessNameLabel.rac_text <~ self.viewmodel.businessName.producer
            |> takeUntil(
                rac_prepareForReuseSignal.toSignalProducer()
                    |> toNihil
            )
        
        cityLabel.rac_text <~ self.viewmodel.city.producer
            |> takeUntil(
                rac_prepareForReuseSignal.toSignalProducer()
                    |> toNihil
            )
        
        businessHoursLabel.rac_text <~ self.viewmodel.participation.producer
            |> takeUntil(
                rac_prepareForReuseSignal.toSignalProducer()
                    |> toNihil
            )
        
        etaLabel.rac_text <~ self.viewmodel.eta.producer
            |> takeUntil(
                rac_prepareForReuseSignal.toSignalProducer()
                    |> toNihil
            )
        
        compositeDisposable += self.viewmodel.coverImage.producer
            |> takeUntil(
                rac_prepareForReuseSignal.toSignalProducer()
                    |> toNihil
            )
            |> ignoreNil
            |> start (
                next: { [weak self] in
                    self?.coverImageView.setImageWithAnimation($0)
                },
                completed: { [weak self] in
                    if let this = self {
                        NearbyLogVerbose("<\(_stdlib_getDemangledTypeName(this)): \(unsafeAddressOf(this))> Cover image signal completes.")
                    }
                }
            )
    }
}
