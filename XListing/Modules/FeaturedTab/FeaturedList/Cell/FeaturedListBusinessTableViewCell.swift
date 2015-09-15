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
private let userThumbnailWidth = UIScreen.mainScreen().bounds.height * 0.048
private let userThumbnailGap = userThumbnailWidth * 0.25
private let userShowToParentRatio = 0.764
private let businessImageContainerUIViewWidthToParentRatio = 0.584
private let businessImageContainerUIViewHeightToWidthRatio = 0.63
private let businessImageWidthToParentRatio = 0.9315
private let businessImageHeightToParentRatio = 0.89855
private let numberOfPeopleGoingLabelToParentRatio = 0.39
private let joinButtonWidthToParentRatio = 0.8
private let joinButtonHeightToWidthRatio = 0.43
private let etaLabelUILabelWidthToEtaIconRatio = 2.5
private let priceLabelToetaLabelRatio = 0.6

    //Sizing and margins
private let userThumbnailHeight = userThumbnailWidth * 1.05
    
public final class FeaturedListBusinessTableViewCell : UITableViewCell {
    
    // MARK: - UI Controls - Business Section
    @IBOutlet private weak var businessImageContainerUIView: UIView!
    @IBOutlet private weak var businessImageUIImageView: UIImageView!
    @IBOutlet private weak var bizInfoUIView: UIView!
    @IBOutlet private weak var bizInfoSizingHelperUIView: UIView!
    @IBOutlet private weak var priceIconUIImageView: UIImageView!
    @IBOutlet private weak var priceLabelUILabel: UILabel!
    @IBOutlet private weak var etaIconUIImageVIew: UIImageView!
    @IBOutlet private weak var businessNameLabelUILabel: UILabel!
    @IBOutlet private weak var cityNameLabelUILabel: UILabel!
    @IBOutlet private weak var etaLabelUILabel: UILabel!
    private lazy var infoPanelXibUIView: UIView = UINib(nibName: "infopanel", bundle: NSBundle.mainBundle()).instantiateWithOwner(self, options: nil).first as! UIView
    
    // MARK: - UI Controls - Social Section
    @IBOutlet private weak var participationUIView: UIView!
    @IBOutlet private weak var joinButtonContainerUIView: UIView!
    @IBOutlet private weak var numberOfPeopleGoingUIView: UIView!
    @IBOutlet private weak var numberOfPeopleGoingLabelUILabel: UILabel!
    @IBOutlet private weak var avatarList: UIView!
    @IBOutlet private weak var joinButton: UIButton!
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
        participationUIView.addSubview(participationViewXibUIView)
        
        //Set card's Background color
        businessImageContainerUIView.backgroundColor = .x_FeaturedCardBG()
        bizInfoUIView.backgroundColor = .x_FeaturedCardBG()
        bizInfoSizingHelperUIView.backgroundColor = .x_FeaturedCardBG()
        businessImageUIImageView.backgroundColor = .x_FeaturedCardBG()
        numberOfPeopleGoingUIView.backgroundColor = .x_FeaturedCardBG()
        joinButtonContainerUIView.backgroundColor = .x_FeaturedCardBG()
        joinButton.backgroundColor = .x_FeaturedCardBG()
        infoPanelXibUIView.backgroundColor = .x_FeaturedCardBG()
        participationUIView.backgroundColor = .x_FeaturedCardBG()
        participationViewXibUIView.backgroundColor = .x_FeaturedCardBG()
        cityNameLabelUILabel.backgroundColor = .x_FeaturedCardBG()
        etaLabelUILabel.backgroundColor = .x_FeaturedCardBG()
        businessNameLabelUILabel.backgroundColor = .x_FeaturedCardBG()
        numberOfPeopleGoingLabelUILabel.backgroundColor = .x_FeaturedCardBG()
        avatarList.backgroundColor = .x_FeaturedCardBG()
        
        //Setting auto-adjust font size
        etaLabelUILabel.adjustsFontSizeToFitWidth = true
        priceLabelUILabel.adjustsFontSizeToFitWidth = true
        numberOfPeopleGoingLabelUILabel.adjustsFontSizeToFitWidth = true
        joinButton.titleLabel?.adjustsFontSizeToFitWidth = true
        
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
        
        //Setup joinButton
        let join = Action<UIButton, Bool, NSError>{ button in
            return self.viewmodel.participate(ParticipationChoice.我想去)
        }
        
        joinButton.addTarget(join.unsafeCocoaAction, action: CocoaAction.selector, forControlEvents: UIControlEvents.TouchUpInside)
        
        $.once({ [weak self] () -> () in
            if let this = self {
                AssetFactory.getImage(Asset.JoinButton(size: this.joinButton.frame.size, backgroundColor: .x_FeaturedCardBG(), opaque: nil, imageContextScale: nil, ifAA: false, ifGo: false, ifPay: false, ifUnTapped: true))
                    |> map { Optional<UIImage>($0) }
                    |> takeUntilPrepareForReuse(this)
                    |> start(next: { image in
                        self?.joinButton.setBackgroundImage(image, forState: .Normal)
                    })

                AssetFactory.getImage(Asset.JoinButton(size: this.joinButton.frame.size, backgroundColor: .x_FeaturedCardBG(), opaque: nil, imageContextScale: nil, ifAA: false, ifGo: true, ifPay: false, ifUnTapped: false))
                    |> map { Optional<UIImage>($0) }
                    |> takeUntilPrepareForReuse(this)
                    |> start(next: { image in
                        self?.joinButton.setBackgroundImage(image, forState: .Disabled)
                    })
            }
        })()

        joinButton.titleLabel?.backgroundColor = .x_FeaturedCardBG()
        joinButton.titleLabel?.layer.masksToBounds = true
        joinButton.layer.rasterizationScale = UIScreen.mainScreen().scale
        joinButton.layer.shouldRasterize = true
        joinButton.hidden = true
        //When the cell is prepared for reuse, set the state.
        rac_prepareForReuseSignal.toSignalProducer()
            |> takeUntilPrepareForReuse(self)
            |> start(next: { [weak self] _ in
                self?.isReusedCell.put(true)
            })
        
        //Setup avatar image views.
        let count = Int(floor((avatarList.frame.width - userThumbnailWidth) / (userThumbnailWidth + userThumbnailGap))) + 1
        var previousImageView: UIImageView? = nil
        for i in 1...count {
            
            let imageView = UIImageView(frame: CGRect(x: 0.0, y: 0.0, width: floor(userThumbnailWidth), height: floor(userThumbnailHeight)))
            // TODO: set the correct background color
            imageView.backgroundColor = .x_FeaturedCardBG()
            imageView.opaque = true
            imageView.contentMode = .Center
            imageView.clipsToBounds = true
            
            avatarList.addSubview(imageView)
            
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
    }
    
    
    public override func updateConstraints() {

        // only run the setup constraints the first time the cell is constructed for perfomance reason
        $.once({ [weak self] Void -> Void in
            if let this = self {
                //Set anchor size for all related views
                constrain(this.businessImageContainerUIView) { businessImageContainerUIView in
                    //sizes
                    businessImageContainerUIView.width == businessImageContainerUIView.superview!.width * businessImageContainerUIViewWidthToParentRatio
                    businessImageContainerUIView.height == businessImageContainerUIView.width * businessImageContainerUIViewHeightToWidthRatio
                }

                //Set business image size
                constrain(this.businessImageUIImageView) {businessImageUIImageView in
                    businessImageUIImageView.width == businessImageUIImageView.superview!.width * businessImageWidthToParentRatio
                    businessImageUIImageView.height == businessImageUIImageView.superview!.height * businessImageHeightToParentRatio
                    businessImageUIImageView.center == businessImageUIImageView.superview!.center
                }
                
                //Make subview same size as the parent view
                constrain(this.infoPanelXibUIView) { infoPanelXibUIView in
                    infoPanelXibUIView.width == infoPanelXibUIView.superview!.width
                    infoPanelXibUIView.height == infoPanelXibUIView.superview!.height
                    infoPanelXibUIView.center == infoPanelXibUIView.superview!.center
                }
                
                
                //Make subview same size as the parent view
                constrain(this.participationViewXibUIView, this.businessImageUIImageView) { participationViewXibUIView, businessImageUIImageView in
                    participationViewXibUIView.width == participationViewXibUIView.superview!.width * userShowToParentRatio
                    participationViewXibUIView.height == participationViewXibUIView.superview!.height
                    participationViewXibUIView.leading == businessImageUIImageView.leading
                    participationViewXibUIView.centerY == participationViewXibUIView.superview!.centerY
                }
                
                //Set numberOfPeopleGoingLabelUILabel size
                constrain(this.numberOfPeopleGoingLabelUILabel) { numberOfPeopleGoingLabelUILabel in
                    numberOfPeopleGoingLabelUILabel.width == numberOfPeopleGoingLabelUILabel.superview!.width * numberOfPeopleGoingLabelToParentRatio
                }
                
                //Set WTG button size
                constrain(this.joinButton, this.etaLabelUILabel) { joinButton, etaLabelUILabel in
                    joinButton.width == joinButton.superview!.width * joinButtonWidthToParentRatio
                    joinButton.height == joinButton.width * joinButtonHeightToWidthRatio
                    joinButton.right == etaLabelUILabel.right
                }
                
                //Set eta and price labels
                constrain(this.etaIconUIImageVIew, this.etaLabelUILabel, this.priceLabelUILabel) {etaIconUIImageVIew, etaLabelUILabel, priceLabelUILabel in
                    etaLabelUILabel.width == etaIconUIImageVIew.width * etaLabelUILabelWidthToEtaIconRatio
                    priceLabelUILabel.width == etaLabelUILabel.width * priceLabelToetaLabelRatio
                }
            }
        })()
        
        super.updateConstraints()
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
                    self?.joinButton.enabled = input
                    self?.joinButton.hidden  = false
                })
        
        businessNameLabelUILabel.rac_text <~ viewmodel.businessName.producer
           |> takeUntilPrepareForReuse(self)
        
        cityNameLabelUILabel.rac_text <~ viewmodel.city.producer
            |> takeUntilPrepareForReuse(self)
        
        viewmodel.price.producer
            |> takeUntilPrepareForReuse(self)
            |> ignoreNil
            |> start(next: { [weak self] price in
                self?.priceLabelUILabel.text = "\(price)"
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
                                    |> map { $0.maskWithRoundedRect(avatarView.bounds.size, cornerRadius: floor(avatarView.bounds.height), backgroundColor: .x_FeaturedCardBG()) }
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
