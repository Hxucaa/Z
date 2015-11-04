//
//  FeaturedListBusinessCell_ParticipationView.swift
//  XListing
//
//  Created by Lance Zhu on 2015-09-15.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import UIKit
import ReactiveCocoa
import TZStackView
import Cartography
import TTTAttributedLabel
import XAssets
import Dollar

private let Preview = (
    Width: round(UIScreen.mainScreen().bounds.height * 0.05),
    Height: round(UIScreen.mainScreen().bounds.height * 0.05 * 1.05),
    Spacing: CGFloat(4)
)
private let wtgIconSize = round(UIScreen.mainScreen().bounds.width * 0.0453)
private let treatIconSize = round(UIScreen.mainScreen().bounds.width * 0.0533)
private let labelSize = round(UIScreen.mainScreen().bounds.width * 0.04)

public final class FeaturedListBusinessCell_ParticipationView : UIView {
    
    // MARK: - UI Controls
    
    
    private lazy var participantsPreviewView: TZStackView = {
        let arrangedSubviews = [self.preview1ImageView, self.preview2ImageView, self.preview3ImageView, self.preview4ImageView, self.preview5ImageView]
        let view = TZStackView(arrangedSubviews: arrangedSubviews)
        
        view.distribution = TZStackViewDistribution.FillEqually
        view.axis = .Horizontal
        view.spacing = Preview.Spacing
        view.alignment = TZStackViewAlignment.Center
        view.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, round(self.frame.width * 0.70),  self.frame.height)
        
        constrain(arrangedSubviews) { views in
            $.each(views) { index, view in
                view.height == view.width * 1.05
            }
        }
        
        return view
    }()
    
    private lazy var previewImageViews: [UIImageView] = [self.preview1ImageView, self.preview2ImageView, self.preview3ImageView, self.preview4ImageView, self.preview5ImageView]
    
    private lazy var preview1ImageView: UIImageView = self.generatePreviewImageView(CGPointMake(Preview.Spacing, 0))
    private lazy var preview2ImageView: UIImageView = self.generatePreviewImageView(CGPointMake(Preview.Spacing + Preview.Width, 0))
    private lazy var preview3ImageView: UIImageView = self.generatePreviewImageView(CGPointMake(Preview.Spacing + Preview.Width * 2, 0))
    private lazy var preview4ImageView: UIImageView = self.generatePreviewImageView(CGPointMake(Preview.Spacing + Preview.Width * 3, 0))
    private lazy var preview5ImageView: UIImageView = self.generatePreviewImageView(CGPointMake(Preview.Spacing + Preview.Width * 4, 0))
    
    private func generatePreviewImageView(origin: CGPoint) -> UIImageView {
        let imageView = UIImageView(frame: CGRectMake(origin.x, origin.y, Preview.Width, Preview.Width))
        imageView.contentMode = UIViewContentMode.ScaleAspectFill
        imageView.backgroundColor = .x_FeaturedCardBG()
        imageView.clipsToBounds = true
                
        return imageView
    }
    
    private lazy var joinButtonContainer: UIView = {
        let viewWidth = round(self.frame.width * 0.30) - 8
        let view = UIView(frame: CGRectMake(round(self.frame.width * 0.70), 8, viewWidth, 10))
        
        return view
    }()
    
    private lazy var dotLabel: UILabel = {
        let dot = UILabel(frame: CGRectMake(0, 0, 2, 2))
        dot.text = "・"
        dot.textColor = UIColor.x_PrimaryColor()
        dot.textAlignment = .Center
        return dot
    }()
    
    private lazy var wtgView: UIView = {
        let wtgView = UIView(frame: CGRectMake(0, 0, 35, wtgIconSize))

        let imageView = self.makeIconImageView(CGRectMake(0, 0, wtgIconSize, wtgIconSize))
        imageView.rac_image <~ AssetFactory.getImage(Asset.WTGIcon(size: CGSizeMake(20, 20), backgroundColor: .x_FeaturedCardBG(), opaque: nil, imageContextScale: nil, pressed: false, shadow: false))
            .take(1)
            .map { Optional<UIImage>($0) }
        
        let label = UILabel(frame: CGRectMake(wtgIconSize, 2, labelSize, labelSize))
        label.text = "20"
        label.textColor = UIColor.x_PrimaryColor()
        label.adjustsFontSizeToFitWidth = true
        
        wtgView.addSubview(imageView)
        wtgView.addSubview(label)
        
        constrain(imageView, label) { imageView, label in
            label.leading == imageView.trailing + 1
            label.bottom == imageView.bottom
            label.width == labelSize
            label.height == labelSize
        }
        
        let tapGesture = UITapGestureRecognizer()
        wtgView.addGestureRecognizer(tapGesture)
        
        return wtgView
    }()
    
    private lazy var treatView: UIView = {
        let treatView = UIView(frame: CGRectMake(0, 0, 35, treatIconSize))
        let imageView = self.makeIconImageView(CGRectMake(0, 0, treatIconSize, treatIconSize))
        
        imageView.rac_image <~ AssetFactory.getImage(Asset.TreatIcon(size: CGSizeMake(20, 20), backgroundColor: .x_FeaturedCardBG(), opaque: nil, imageContextScale: nil, pressed: false, shadow: false))
            .take(1)
            .map { Optional<UIImage>($0) }
        
        let label = UILabel(frame: CGRectMake(treatIconSize, 3, labelSize, labelSize))
        label.text = "20"
        label.textColor = UIColor.x_PrimaryColor()
        label.adjustsFontSizeToFitWidth = true
        
        treatView.addSubview(imageView)
        treatView.addSubview(label)
        
        constrain(imageView, label) { imageView, label in
            label.leading == imageView.trailing
            label.bottom == imageView.bottom - (treatIconSize - wtgIconSize) / 2
            label.width == labelSize
            label.height == labelSize
        }
        
        let tapGesture = UITapGestureRecognizer()
        treatView.addGestureRecognizer(tapGesture)
        
        return treatView
    }()
    
    private func makeIconImageView(frame: CGRect) -> UIImageView {
        let imageView = UIImageView(frame: frame)
        imageView.contentMode = UIViewContentMode.ScaleAspectFit
        imageView.opaque = true
        imageView.backgroundColor = .x_FeaturedCardBG()
        
        return imageView
    }
    
    // MARK: - Properties
    private var viewmodel: IFeaturedListBusinessCell_ParticipationViewModel!
    private let compositeDisposable = CompositeDisposable()
    
    // MARK: - Initializers
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setup()
    }
    
    // MARK: - Setups
    
    private func setup() {
        
        backgroundColor = UIColor.x_FeaturedCardBG()
        
        addSubview(participantsPreviewView)
        addSubview(joinButtonContainer)
        
        constrain(participantsPreviewView, joinButtonContainer) { container, button in
            container.leading == container.superview!.leadingMargin
            container.top == container.superview!.top
            container.width == container.superview!.width * 0.62
            container.bottom == container.superview!.bottom
            
            (button.top == button.superview!.topMargin).identifier = "joinButtonContainer top"
            (button.trailing == button.superview!.trailingMargin - 8).identifier = "joinButtonContainer trailing"
            (button.bottom == button.superview!.bottomMargin).identifier = "joinButtonContainer bottom"
        }
        
        joinButtonContainer.addSubview(wtgView)
        joinButtonContainer.addSubview(treatView)
        joinButtonContainer.addSubview(dotLabel)
        
        constrain(wtgView, treatView, dotLabel) { wtgView, treatView, dotLabel in
            align(centerY: wtgView, treatView, dotLabel)
            
            dotLabel.center == dotLabel.superview!.center
            
            wtgView.height == wtgIconSize
            wtgView.width == wtgIconSize+labelSize+1
            treatView.height == treatIconSize
            treatView.width == treatIconSize+labelSize
            
            wtgView.trailing == dotLabel.leading + 2
            dotLabel.trailing == treatView.leading
            
            wtgView.leading <= wtgView.superview!.leading ~ 250
            treatView.trailing == treatView.superview!.trailing
        }
    }
    
    // MARK: - Bindings
    
    public func bindToViewModel(viewmodel: IFeaturedListBusinessCell_ParticipationViewModel) {
        self.viewmodel = viewmodel
        
//        joinButton.rac_enabled <~ viewmodel.buttonEnabled.producer
//            .takeUntilPrepareForReuse(self)
//
//        viewmodel.buttonEnabled.producer
//            .ignoreNil
//            .start(next: {[weak self] input in
//                    self?.joinButtonUIButton.enabled = input
//                    self?.joinButtonUIButton.hidden  = false
//                })
        
        compositeDisposable += self.viewmodel.getParticipantPreview()
            .start()
        
        compositeDisposable += self.viewmodel.getUserParticipation()
            .start()
        
        compositeDisposable += self.viewmodel.participantViewModelArr.producer
            .filter { $0.count > 0 }
            .start { [weak self] event in
                switch event {
                case .Next(let participants):
                    
                    if let this = self {
                        
                        // iterate through previewImageViews
                        $.each(this.previewImageViews) { index, view in
                            if index < participants.count {
                                
                                // place the image into image view
                                participants[index].avatar.producer
                                    .ignoreNil()
                                    .map { $0.maskWithRoundedRect(view.frame.size, cornerRadius: view.frame.size.width, backgroundColor: .x_FeaturedCardBG()) }
                                    .startWithNext { image in
                                        view.image = image
                                    }
                            }
                        }
                    }
                default: break
                }
            }
    }
    
    // MARK: - Others
    
    public func initiateReuse() {
        
        $.each(previewImageViews) { index, view in
            view.image = nil
        }
    }
}