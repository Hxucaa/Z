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
    @IBOutlet weak var businessImage: UIImageView!
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var participationView: UIView!
    
    
    // MARK: Properties
    private var infoViewContent: InfoPanel!
    private var participationViewContent: ParticipationView!
    private var viewmodel: FeaturedBusinessViewModel!
    private let compositeDisposable = CompositeDisposable()
    /// whether this instance of cell has been reused
    private let isReusedCell = MutableProperty<Bool>(false)
    
    // MARK: Setups
    
    public override func awakeFromNib() {
        selectionStyle = UITableViewCellSelectionStyle.None
        
        layoutMargins = UIEdgeInsetsZero
        preservesSuperviewLayoutMargins = false
        
        var infoViewContent = NSBundle.mainBundle().loadNibNamed("infopanel", owner: self, options: nil)[0] as! InfoPanel
        infoView.addSubview(infoViewContent)
        
        var participationViewContent = NSBundle.mainBundle().loadNibNamed("participationview", owner: self, options: nil)[0] as! ParticipationView
        participationView.addSubview(participationViewContent)
        
        
        /**
        *  When the cell is prepared for reuse, set the state.
        *
        */
        compositeDisposable += rac_prepareForReuseSignal.toSignalProducer()
            |> start(next: { [weak self] _ in
                self?.isReusedCell.put(true)
            })
    }
    
    deinit {
        compositeDisposable.dispose()
    }
    
    // MARK: Bindings
    
    public func bindViewModel(viewmodel: FeaturedBusinessViewModel) {
        self.viewmodel = viewmodel
        
//        self.infoViewContent.name.rac_text <~ viewmodel.businessName.producer
//           |> takeUntilPrepareForReuse(self)
//
//        cityLabel.rac_text <~ viewmodel.city.producer
//            |> takeUntilPrepareForReuse(self)
//        
//        participationLabel.rac_text <~ viewmodel.participation.producer
//            |> takeUntilPrepareForReuse(self)
//        
//        etaLabel.rac_text <~ viewmodel.eta.producer
//            |> takeUntilPrepareForReuse(self)
//        
//        compositeDisposable += self.viewmodel.coverImage.producer
//            |> takeUntilPrepareForReuse(self)
//            |> ignoreNil
//            |> start (next: { [weak self] image in
//                // if this cell is reused or when the cover image in viewmodel has already been displayed, then do not display the image with fancy animation
//                if let viewmodel = self?.viewmodel, isReusedCell = self?.isReusedCell where viewmodel.isCoverImageConsumed.value || isReusedCell.value {
//                    self?.coverImageView.rac_image.put(image)
//                }
//                // otherwise display the image without animation
//                else {
//                    self?.coverImageView.setImageWithAnimation(image)
//                    viewmodel.isCoverImageConsumed.put(true)
//                }
//            })
    }
}