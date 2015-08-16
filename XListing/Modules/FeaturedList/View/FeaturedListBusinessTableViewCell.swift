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
import Cartography

public final class FeaturedListBusinessTableViewCell : UITableViewCell {
    
    // MARK: - UI Controls
    @IBOutlet weak var businessImage: UIImageView!
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var participationView: UIView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var etaLabel: UILabel!
    
    @IBOutlet weak var peopleWantogoLabel: UILabel!
    @IBOutlet weak var avatarList: UIView!
    @IBOutlet weak var joinButton: UIButton!
    
    // MARK: Properties

    private var viewmodel: FeaturedBusinessViewModel!
    private let compositeDisposable = CompositeDisposable()
    /// whether this instance of cell has been reused
    private let isReusedCell = MutableProperty<Bool>(false)
    
    // MARK: Setups
    
    public override func awakeFromNib() {
        selectionStyle = UITableViewCellSelectionStyle.None
        layoutMargins = UIEdgeInsetsZero
        preservesSuperviewLayoutMargins = false
        
        
        
        //add layouts
        
        layout(businessImage, participationView) { businessImage, participationView in

            //sizes
            businessImage.width == businessImage.superview!.width * 0.544
            businessImage.height == businessImage.width * 0.6078

            
        }

        var infoViewContent = NSBundle.mainBundle().loadNibNamed("infopanel", owner: self, options: nil)[0] as! UIView
        infoView.addSubview(infoViewContent)
        
        var participationViewContent = NSBundle.mainBundle().loadNibNamed("participationview", owner: self, options: nil)[0] as! UIView
        participationView.addSubview(participationViewContent)
        
        
        //Make subview same size as the parent view
        
        layout(infoViewContent, participationViewContent) { infoViewContent, participationViewContent in
            infoViewContent.left == infoViewContent.superview!.left
            infoViewContent.top == infoViewContent.superview!.top
            infoViewContent.width == infoViewContent.superview!.width
            infoViewContent.height == infoViewContent.superview!.height
            
            participationViewContent.left == participationViewContent.superview!.left
            participationViewContent.top == participationViewContent.superview!.top
            participationViewContent.width == participationViewContent.superview!.width
            participationViewContent.height == participationViewContent.superview!.height
        }
        
    

        
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
        
        self.nameLabel.rac_text <~ viewmodel.businessName.producer
           |> takeUntilPrepareForReuse(self)
        self.cityLabel.rac_text <~ viewmodel.city.producer
            |> takeUntilPrepareForReuse(self)
        self.priceLabel.rac_text <~ viewmodel.price.producer
            |> takeUntilPrepareForReuse(self)
        self.etaLabel.rac_text <~ viewmodel.eta.producer
            |> takeUntilPrepareForReuse(self)
        self.peopleWantogoLabel.rac_text <~ viewmodel.participation.producer
            |> takeUntilPrepareForReuse(self)
        compositeDisposable += self.viewmodel.coverImage.producer
            |> takeUntilPrepareForReuse(self)
            |> ignoreNil
            |> start (next: { [weak self] image in
                if let viewmodel = self?.viewmodel, isReusedCell = self?.isReusedCell where viewmodel.isCoverImageConsumed.value || isReusedCell.value {
                    self?.businessImage.rac_image.put(image)
                }
                else {
                    self?.businessImage.setImageWithAnimation(image)
                    viewmodel.isCoverImageConsumed.put(true)
                }
            })
    }
}