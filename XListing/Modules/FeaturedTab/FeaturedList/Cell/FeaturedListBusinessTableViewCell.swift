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
import XAssets
import Dollar

    
    //Layout Ratios
private let userThumbnailWidth = round(UIScreen.mainScreen().bounds.height * 0.048)
private let userThumbnailGap = round(userThumbnailWidth * 0.25)
private let userShowToParentRatio = 0.764
private let businessImageContainerWidthToParentRatio = 0.584
private let businessImageContainerHeightToWidthRatio = 0.63
private let businessImageWidthToParentRatio = 0.9315
private let businessImageHeightToParentRatio = 0.89855
private let numberOfPeopleGoingLabelToParentRatio = 0.39
private let joinButtonWidthToParentRatio = 0.8
private let joinButtonHeightToWidthRatio = 0.43
private let etaLabelUILabelWidthToEtaIconRatio = 2.5
private let priceLabelToEtaLabelRatio = 0.6

    //Sizing and margins
private let userThumbnailHeight = round(userThumbnailWidth * 1.05)
private let bizInfoUIViewLeadingMargin = 8.0
private let featuredCardLeftAndRightMargin = 8.0
private let featuredCardTopAndBottomMargin = 6.0
    
public final class FeaturedListBusinessTableViewCell : UITableViewCell {
    
    // MARK: - UI Controls - Business Section
    @IBOutlet private weak var businessImageContainerUIView: UIView!
    @IBOutlet private weak var businessImageUIImageView: UIImageView!
    @IBOutlet private weak var bizInfoUIView: UIView!
    @IBOutlet private weak var businessSocialDividerUIView: UIView!
    @IBOutlet private weak var priceIconUIImageView: UIImageView!
    @IBOutlet private weak var priceLabelUILabel: UILabel!
    @IBOutlet private weak var etaIconUIImageVIew: UIImageView!
    @IBOutlet private weak var businessNameLabelUILabel: UILabel!
    @IBOutlet private weak var cityNameLabelUILabel: UILabel!
    @IBOutlet private weak var etaLabelUILabel: UILabel!
    private lazy var infoPanelXibUIView: UIView = UINib(nibName: "infopanel", bundle: NSBundle.mainBundle()).instantiateWithOwner(self, options: nil).first as! UIView
    
    // MARK: - UI Controls - Social Section
    @IBOutlet private weak var userThumbnailShowContainerUIView: UIView!
    @IBOutlet private weak var joinButtonContainerUIView: UIView!
    @IBOutlet private weak var numberOfPeopleGoingUIView: UIView!
    @IBOutlet private weak var numberOfPeopleGoingLabelUILabel: UILabel!
    @IBOutlet private weak var userThumbnailShowUIView: UIView!
    @IBOutlet private weak var joinButtonUIButton: UIButton!
    private lazy var participationViewXibUIView: UIView = UINib(nibName: "participationview", bundle: NSBundle.mainBundle()).instantiateWithOwner(self, options: nil).first as! UIView
    private var avatarImageViews = [UIImageView]()

    // MARK: Properties
    private var viewmodel: FeaturedBusinessViewModel!
    
    /// whether this instance of cell has been reused
    private let isReusedCell = MutableProperty<Bool>(false)

    // MARK: Setups
    public override func awakeFromNib() {
        selectionStyle = UITableViewCellSelectionStyle.None
        layoutMargins = UIEdgeInsetsZero
        preservesSuperviewLayoutMargins = false
        
        bizInfoUIView.addSubview(infoPanelXibUIView)
        userThumbnailShowContainerUIView.addSubview(participationViewXibUIView)
        
        //Set card's Background color
        businessImageContainerUIView.backgroundColor = .x_FeaturedCardBG()
        bizInfoUIView.backgroundColor = .x_FeaturedCardBG()
        businessImageUIImageView.backgroundColor = .x_FeaturedCardBG()
        numberOfPeopleGoingUIView.backgroundColor = .x_FeaturedCardBG()
        joinButtonContainerUIView.backgroundColor = .x_FeaturedCardBG()
        joinButtonUIButton.backgroundColor = .x_FeaturedCardBG()
        infoPanelXibUIView.backgroundColor = .x_FeaturedCardBG()
        userThumbnailShowContainerUIView.backgroundColor = .x_FeaturedCardBG()
        participationViewXibUIView.backgroundColor = .x_FeaturedCardBG()
        cityNameLabelUILabel.backgroundColor = .x_FeaturedCardBG()
        etaLabelUILabel.backgroundColor = .x_FeaturedCardBG()
        businessNameLabelUILabel.backgroundColor = .x_FeaturedCardBG()
        numberOfPeopleGoingLabelUILabel.backgroundColor = .x_FeaturedCardBG()
        userThumbnailShowUIView.backgroundColor = .x_FeaturedCardBG()
        
        //Setting auto-adjust font size
        etaLabelUILabel.adjustsFontSizeToFitWidth = true
        priceLabelUILabel.adjustsFontSizeToFitWidth = true
        numberOfPeopleGoingLabelUILabel.adjustsFontSizeToFitWidth = true
        joinButtonUIButton.titleLabel?.adjustsFontSizeToFitWidth = true
        
        businessImageUIImageView.layer.masksToBounds = true
        businessNameLabelUILabel.layer.masksToBounds = true
        etaLabelUILabel.layer.masksToBounds = true
        
        
        
        priceIconUIImageView.rac_image <~ AssetFactory.getImage(Asset.PriceIcon(size: CGSizeMake(priceIconUIImageView.frame.width, priceIconUIImageView.frame.height), backgroundColor: .x_FeaturedCardBG(), opaque: nil, imageContextScale: nil, pressed: false, shadow: false))
            |> take(1)
            |> map { Optional<UIImage>($0) }
        
        priceIconUIImageView.layer.rasterizationScale = UIScreen.mainScreen().scale
        priceIconUIImageView.layer.shouldRasterize = true
        
        // Adding ETA icon
        etaIconUIImageVIew.rac_image <~ AssetFactory.getImage(Asset.CarIcon(size: etaIconUIImageVIew.frame.size, backgroundColor: .x_FeaturedCardBG(), opaque: nil, imageContextScale: nil, pressed: false, shadow: false))
            |> take(1)
            |> map { Optional<UIImage>($0) }
        
        etaIconUIImageVIew.layer.rasterizationScale = UIScreen.mainScreen().scale
        etaIconUIImageVIew.layer.shouldRasterize = true
        
        
        //When the cell is prepared for reuse, set the state.
        rac_prepareForReuseSignal.toSignalProducer()
            |> takeUntilPrepareForReuse(self)
            |> start(next: { [weak self] _ in
                self?.isReusedCell.put(true)
            })
        
        //Setup avatar image views.
        let count = Int((userThumbnailShowUIView.frame.width - userThumbnailWidth) / (userThumbnailWidth + userThumbnailGap)) + 1
        var previousImageView: UIImageView? = nil
        for i in 1...count {
            
            let imageView = UIImageView(frame: CGRect(x: 0.0, y: 0.0, width: round(userThumbnailWidth), height: round(userThumbnailHeight)))
            // TODO: set the correct background color
            imageView.backgroundColor = .x_FeaturedCardBG()
            imageView.contentMode = .Center
            imageView.clipsToBounds = true
            
            userThumbnailShowUIView.addSubview(imageView)
            
            if i == 1 {
                constrain(imageView) { view in
                    view.leading == view.superview!.leading
                    view.centerY == view.superview!.centerY
                    view.width == userThumbnailWidth
                    view.height == view.width * 1.05
                }
            }
            
            if let previousImageView = previousImageView {
                constrain(previousImageView, imageView) { previous, current in
                    previous.trailing == current.leading - userThumbnailGap
                    current.centerY == current.superview!.centerY
                    current.width == userThumbnailWidth
                    current.height == current.width * 1.05
                }
            }
            
            previousImageView = imageView
            avatarImageViews.append(imageView)
            
        }
        
        numberOfPeopleGoingLabelUILabel.backgroundColor = .x_FeaturedCardBG()
        numberOfPeopleGoingLabelUILabel.layer.masksToBounds = true
        
        //Set business image container as anchor for all related views
        constrain(businessImageContainerUIView) { container in
            container.width == container.superview!.width * businessImageContainerWidthToParentRatio
            container.height == container.width * businessImageContainerHeightToWidthRatio
            container.leading == container.superview!.leading + featuredCardLeftAndRightMargin
            container.top == container.superview!.top + featuredCardTopAndBottomMargin
        }
        
        //bizInfoView size and position
        constrain(businessImageContainerUIView, bizInfoUIView) { container, info in
            container.trailing == info.leading
            container.bottom == info.bottom
            container.top == info.top
            info.trailing == info.superview!.trailing - featuredCardLeftAndRightMargin
        }
        
        //Set up biz and social divider
        constrain(businessImageContainerUIView, businessSocialDividerUIView, numberOfPeopleGoingUIView) {container, divider, view in
            container.leading == divider.leading - 9
            container.bottom == divider.top
            divider.height == 1
            divider.trailing == divider.superview!.trailing - featuredCardLeftAndRightMargin
            divider.bottom == view.top + 1
        }
        
        //Set business image size and position
        constrain(businessImageUIImageView) { image in
            image.width == image.superview!.width * businessImageWidthToParentRatio
            image.height == image.superview!.height * businessImageHeightToParentRatio
            image.center == image.superview!.center
        }
        
        
        //Make subview same size as the parent view
        constrain(infoPanelXibUIView) { view in
            view.size == view.superview!.size
            view.center == view.superview!.center
        }
        
        
        //Make subview same size as the parent view
        constrain(participationViewXibUIView, businessImageUIImageView) { view, image in
            view.width == view.superview!.width * userShowToParentRatio
            view.height == view.superview!.height
            view.leading == image.leading
            view.centerY == view.superview!.centerY
        }
        
        //Set numberOfPeopleGoingLabelUILabel size
        constrain(numberOfPeopleGoingLabelUILabel) { label in
            label.width == label.superview!.width * numberOfPeopleGoingLabelToParentRatio
        }
        
        //Set up business name label
        constrain(businessNameLabelUILabel, cityNameLabelUILabel) { business, city in
            business.leading == business.superview!.leading + bizInfoUIViewLeadingMargin
            business.top == business.superview!.top + 14
            business.leading == city.leading - 1
            business.bottom == city.top + 1.5
            city.height == 21
        }
        
        //Set price icon and label
        constrain(priceIconUIImageView, priceLabelUILabel) { icon, label in
            icon.width == icon.superview!.width / 13
            icon.height == icon.width
            icon.bottom == icon.superview!.bottom / 1.24
            icon.leading == icon.superview!.leading + bizInfoUIViewLeadingMargin
            label.leading == icon.trailing + 3
            label.centerY == icon.centerY
        }
        
        //Set eta icon size
        constrain(etaIconUIImageVIew) { icon in
            icon.width == icon.superview!.width / 11
            icon.height == icon.width * 13 / 14
            icon.bottom == icon.superview!.bottom / 1.23
        }
        
        //Set eta and price labels
        constrain(etaIconUIImageVIew, etaLabelUILabel, priceLabelUILabel) { etaIcon, etaLabel, priceLabel in
            etaLabel.width == etaIcon.width * etaLabelUILabelWidthToEtaIconRatio
            priceLabel.width == etaLabel.width * priceLabelToEtaLabelRatio
            etaIcon.trailing == etaLabel.leading - 3
            etaIcon.centerY == etaLabel.centerY
        }
        
        //Set up userThumbnailContainerView
        constrain(userThumbnailShowContainerUIView, numberOfPeopleGoingUIView, joinButtonContainerUIView) { container, view, button in
            container.trailing == container.superview!.trailing / 1.285 - featuredCardLeftAndRightMargin
            container.leading == container.superview!.leading + featuredCardLeftAndRightMargin
            container.bottom == container.superview!.bottom - 2
            view.leading == view.superview!.leading + featuredCardLeftAndRightMargin
            view.height == 21
            view.top == button.top
            container.trailing == view.trailing
            container.trailing == button.leading
            container.bottom == button.bottom
            container.top == view.bottom
            button.trailing == button.superview!.trailing - featuredCardLeftAndRightMargin
        }
        
        //set up numberofpeoplegoinglabel
        constrain(numberOfPeopleGoingLabelUILabel) { label in
            label.leading == label.superview!.leading + 12
            label.bottom == label.superview!.bottom - 2
            label.top == label.superview!.top + 3
        }
        
        //Set up userThumbnailShowUIView
        constrain(userThumbnailShowUIView) { view in
            view.size == view.superview!.size
            view.center == view.superview!.center
        }
        
        //setup join button
        constrain(joinButtonUIButton, etaLabelUILabel) { button, label in
            button.centerY == button.superview!.centerY / 0.82
            button.trailing == button.superview!.trailing * 0.8
            button.width == button.superview!.width * 0.7
            button.height == button.width * 32 / 69
            button.trailing == label.trailing
        }
        
        //Setup joinButton
        let join = Action<UIButton, Bool, NSError>{ button in
            return self.viewmodel.participate(ParticipationChoice.我想去)
        }
        
        joinButtonUIButton.addTarget(join.unsafeCocoaAction, action: CocoaAction.selector, forControlEvents: UIControlEvents.TouchUpInside)
        
        $.once({ [weak self] () -> () in
            if let this = self {
                AssetFactory.getImage(Asset.JoinButton(size: this.joinButtonUIButton.frame.size, backgroundColor: .x_FeaturedCardBG(), opaque: nil, imageContextScale: nil, ifAA: false, ifGo: false, ifPay: false, ifUnTapped: true))
                    |> map { Optional<UIImage>($0) }
                    |> takeUntilPrepareForReuse(this)
                    |> start(next: { image in
                        self?.joinButtonUIButton.setBackgroundImage(image, forState: .Normal)
                    })
                
                AssetFactory.getImage(Asset.JoinButton(size: this.joinButtonUIButton.frame.size, backgroundColor: .x_FeaturedCardBG(), opaque: nil, imageContextScale: nil, ifAA: false, ifGo: true, ifPay: false, ifUnTapped: false))
                    |> map { Optional<UIImage>($0) }
                    |> takeUntilPrepareForReuse(this)
                    |> start(next: { image in
                        self?.joinButtonUIButton.setBackgroundImage(image, forState: .Disabled)
                    })
            }
            })()
        
        joinButtonUIButton.titleLabel?.backgroundColor = .x_FeaturedCardBG()
        joinButtonUIButton.titleLabel?.layer.masksToBounds = true
        joinButtonUIButton.layer.rasterizationScale = UIScreen.mainScreen().scale
        joinButtonUIButton.layer.shouldRasterize = true
        joinButtonUIButton.hidden = true
        
    }
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        
        $.each(avatarImageViews) { _, view in
            view.image = nil
        }
    }

    // MARK: Bindings
    public func bindViewModel(viewmodel: FeaturedBusinessViewModel) {
        self.viewmodel = viewmodel
        
//        joinButton.rac_enabled <~ viewmodel.buttonEnabled.producer
//            |> takeUntilPrepareForReuse(self)
  
        viewmodel.buttonEnabled.producer
            |> ignoreNil
            |> start(next: {[weak self] input in
                    self?.joinButtonUIButton.enabled = input
                    self?.joinButtonUIButton.hidden  = false
                })
        
        businessNameLabelUILabel.rac_text <~ viewmodel.businessName.producer
           |> takeUntilPrepareForReuse(self)
        
        cityNameLabelUILabel.rac_text <~ viewmodel.city.producer
            |> takeUntilPrepareForReuse(self)
        
        viewmodel.price.producer
            |> takeUntilPrepareForReuse(self)
            |> ignoreNil
            |> start(next: { [weak self] price in
                self?.priceLabelUILabel.text = "$ \(price)"
                self?.priceLabelUILabel.setNeedsDisplay()
            })
        
        etaLabelUILabel.rac_text <~ viewmodel.eta.producer
            |> takeUntilPrepareForReuse(self)
        
        numberOfPeopleGoingLabelUILabel.rac_text <~ viewmodel.participationString.producer
            |> takeUntilPrepareForReuse(self)
        
        self.viewmodel.coverImage.producer
            |> takeUntilPrepareForReuse(self)
            |> ignoreNil
            |> start (next: { [weak self] image in
                if let viewmodel = self?.viewmodel, isReusedCell = self?.isReusedCell where viewmodel.isCoverImageConsumed.value || isReusedCell.value {
                    self?.businessImageUIImageView.rac_image.put(image)
                }
                else {
                    self?.businessImageUIImageView.setImageWithAnimation(image)
                    viewmodel.isCoverImageConsumed.put(true)
                }
            })
        
        self.viewmodel.participantViewModelArr.producer
            |> takeUntilPrepareForReuse(self)
            |> start (next: { [weak self] participants in
                if let this = self {
                    
                    var filledAvatarImageViews = [UIImageView]()
                    // only add images to image views if the participants count is greater than 0
                    if participants.count > 0 {
                        // iterate through avatarImageViews - 1 (leaving space for etc icon)
                        for i in 0..<(this.avatarImageViews.count - 1) {
                            if i < participants.count {
                                let avatarView = this.avatarImageViews[i]
                                
                                
                                // place the image into image view
                                participants[i].avatar.producer
                                    |> takeUntilPrepareForReuse(this)
                                    |> ignoreNil
                                    |> map { $0.maskWithRoundedRect(CGSizeMake(round(avatarView.bounds.width), round(avatarView.bounds.height)), cornerRadius: round(avatarView.bounds.height), backgroundColor: .x_FeaturedCardBG()) }
                                    |> start(next: { image in
                                        avatarView.image = image
                                    })
                                
                                // unhide the image view
                                avatarView.hidden = false
                                
                                // add the image view to the list of already processed
                                filledAvatarImageViews.append(avatarView)
                            }
                        }
                        
                        let etcImageView = this.avatarImageViews[filledAvatarImageViews.count]
                        
                        $.once({ [weak self] Void -> Void in
                            if let this = self {
                        // assign etc icon to image view
                                etcImageView.rac_image <~ AssetFactory.getImage(Asset.EtcIcon(size: CGSizeMake(8,3), backgroundColor: .x_FeaturedCardBG(), opaque: nil, imageContextScale: nil, pressed: false, shadow: false))
                                    |> map { Optional<UIImage>($0) }
                                    |> takeUntilPrepareForReuse(this)
                                etcImageView.contentMode = .Left
                            }
                        })()
                        
                        // unhide the image view
                        etcImageView.hidden = false
                        
                        
                        // add the image view to the list of already processed
                        filledAvatarImageViews.append(etcImageView)
                    }
                    
                    for i in (filledAvatarImageViews.count)..<(this.avatarImageViews.count) {
                        this.avatarImageViews[i].hidden = true
                    }
                }
            })
    }
}
