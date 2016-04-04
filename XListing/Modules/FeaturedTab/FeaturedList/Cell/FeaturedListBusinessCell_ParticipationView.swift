//
//  FeaturedListBusinessCell_ParticipationView.swift
//  XListing
//
//  Created by Lance Zhu on 2016-04-03.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import UIKit
import TZStackView
import Cartography
import TTTAttributedLabel
import RxSwift
import RxCocoa

private let Preview = (
    Width: round(UIScreen.mainScreen().bounds.height * 0.05),
    Height: round(UIScreen.mainScreen().bounds.height * 0.05 * 1.05),
    Spacing: CGFloat(4)
)
private let wtgIconSize = round(UIScreen.mainScreen().bounds.width * 0.0453)
private let treatIconSize = round(UIScreen.mainScreen().bounds.width * 0.0533)
private let labelSize = round(UIScreen.mainScreen().bounds.width * 0.04)

final class FeaturedListBusinessCell_ParticipationView : UIView {
    
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
            views.enumerate().forEach({ (index, view) in
                view.height == view.width * 1.05
            })
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
    
//    private lazy var joinButtonContainer: UIView = {
//        let viewWidth = round(self.frame.width * 0.30) - 8
//        let view = UIView(frame: CGRectMake(round(self.frame.width * 0.70), 8, viewWidth, 10))
//        
//        return view
//    }()
    
    private lazy var participateButton: DOFavoriteButton = {
        let button = DOFavoriteButton(frame: CGRectMake(wtgIconSize, 2, labelSize, labelSize), image: UIImage(asset: .Wtg), config: .CircleToShape)
        button.imageSelected = UIImage(asset: .Wtg_Filled)
        button.circleColor = UIColor.redColor()
        
        return button
    }()
    
//    private lazy var dotLabel: UILabel = {
//        let dot = UILabel(frame: CGRectMake(0, 0, 2, 2))
//        dot.text = "・"
//        dot.opaque = true
//        dot.backgroundColor = .x_FeaturedCardBG()
//        dot.textColor = UIColor.x_PrimaryColor()
//        dot.textAlignment = .Center
//        dot.layer.masksToBounds = true
//        
//        return dot
//    }()
    
//    private lazy var wtgLabel: UILabel = {
//        let label = UILabel(frame: CGRectMake(wtgIconSize, 2, labelSize, labelSize))
//        label.opaque = true
//        label.backgroundColor = .x_FeaturedCardBG()
//        label.layer.masksToBounds = true
//        label.textColor = UIColor.x_PrimaryColor()
//        label.adjustsFontSizeToFitWidth = true
//        label.textAlignment = .Center
//        
//        return label
//    }()
//    
//    private lazy var wtgImageView: UIImageView = {
//        let imageView = self.makeIconImageView(CGRectMake(0, 0, wtgIconSize, wtgIconSize))
//        
//        return imageView
//    }()
//    
//    private lazy var wtgView: UIView = {
//        let wtgView = UIView(frame: CGRectMake(0, 0, 35, wtgIconSize))
//        
//        return wtgView
//    }()
    
//    private lazy var treatTapGesture: UITapGestureRecognizer = {
//        let tapGesture = UITapGestureRecognizer()
//        
//        let tapTreat = Action<UITapGestureRecognizer, Void, NoError> { [weak self] button in
//            return SignalProducer { observer ,disposable in
//                if let this = self {
//                    disposable += this.viewmodel.participate(ParticipationType.Treat)
//                        .start()
//                    this.treatImageView.rac_image <~ AssetFactory.getImage(Asset.TreatIcon(size: CGSizeMake(20, 20), backgroundColor: .x_FeaturedCardBG(), opaque: nil, imageContextScale: nil, pressed: true, shadow: false))
//                        .take(1)
//                        .map { Optional<UIImage>($0) }
//                    this.treatTapGesture.enabled = false
//                    this.wtgTapGesture.enabled = false
//                    observer.sendCompleted()
//                }
//            }
//        }
//        
//        tapGesture.addTarget(tapTreat.unsafeCocoaAction, action: CocoaAction.selector)
//        
//        return tapGesture
//    }()
//    
//    private lazy var treatImageView: UIImageView = {
//        let imageView = self.makeIconImageView(CGRectMake(0, 0, treatIconSize, treatIconSize))
//        
//        return imageView
//    }()
//    
//    private lazy var treatLabel: UILabel = {
//        let label = UILabel(frame: CGRectMake(treatIconSize, 3, labelSize, labelSize))
//        label.opaque = true
//        label.backgroundColor = .x_FeaturedCardBG()
//        label.layer.masksToBounds = true
//        label.textColor = UIColor.x_PrimaryColor()
//        label.adjustsFontSizeToFitWidth = true
//        label.textAlignment = .Center
//        return label
//    }()
//    
//    private lazy var treatView: UIView = {
//        let treatView = UIView(frame: CGRectMake(0, 0, 35, treatIconSize))
//        
//        return treatView
//    }()
    
    
    private func makeIconImageView(frame: CGRect) -> UIImageView {
        let imageView = UIImageView(frame: frame)
        imageView.contentMode = UIViewContentMode.ScaleAspectFit
        imageView.opaque = true
        imageView.backgroundColor = .x_FeaturedCardBG()
        
        return imageView
    }
    
    // MARK: - Properties
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setup()
    }
    
    // MARK: - Setups
    
    private func setup() {
        
        backgroundColor = UIColor.x_FeaturedCardBG()
        
        addSubview(participantsPreviewView)
        addSubview(participateButton)
//        addSubview(joinButtonContainer)
        
        constrain(participantsPreviewView, participateButton) { container, button in
            container.leading == container.superview!.leadingMargin
            container.top == container.superview!.top
            container.width == container.superview!.width * 0.655
            container.bottom == container.superview!.bottom
            
            button.leading == container.trailing
            (button.top == button.superview!.topMargin).identifier = "joinButtonContainer top"
            (button.trailing == button.superview!.trailingMargin - 8).identifier = "joinButtonContainer trailing"
            (button.bottom == button.superview!.bottomMargin).identifier = "joinButtonContainer bottom"
        }
        
        // TODO: hook up tap
        participateButton.rx_tap
        
//        wtgView.addSubview(wtgImageView)
//        wtgView.addSubview(wtgLabel)
//        
//        constrain(wtgImageView, wtgLabel) { imageView, label in
//            label.leading == imageView.trailing + 1
//            label.bottom == imageView.bottom
//            label.width == labelSize
//            label.height == labelSize
//        }
        
//        treatView.addSubview(treatImageView)
//        treatView.addSubview(treatLabel)
//        
//        constrain(treatImageView, treatLabel) { imageView, label in
//            label.leading == imageView.trailing
//            label.bottom == imageView.bottom - (treatIconSize - wtgIconSize) / 2
//            label.width == labelSize
//            label.height == labelSize
//        }
//        let wtgTapGesture = Action<UITapGestureRecognizer, Void, NoError> { [weak self] button in
//            return SignalProducer { observer ,disposable in
//                if let this = self {
//                    disposable += this.viewmodel.participate(ParticipationType.ToGo)
//                        .start()
//                    this.wtgImageView.rac_image <~ AssetFactory.getImage(Asset.WTGIcon(size: CGSizeMake(20, 20), backgroundColor: .x_FeaturedCardBG(), opaque: nil, imageContextScale: nil, pressed: true, shadow: false))
//                        .take(1)
//                        .map { Optional<UIImage>($0) }
//                    this.wtgTapGesture.enabled = false
//                    this.treatTapGesture.enabled = false
//                    observer.sendCompleted()
//                }
//            }
//        }
//        
//        tapGesture.addTarget(tapToGo.unsafeCocoaAction, action: CocoaAction.selector)
        
//        participateButton
        
        
        
//        treatView.addGestureRecognizer(treatTapGesture)
        
//        joinButtonContainer.addSubview(wtgView)
//        joinButtonContainer.addSubview(treatView)
//        joinButtonContainer.addSubview(dotLabel)
        
//        constrain(wtgView, treatView, dotLabel) { wtgView, treatView, dotLabel in
//            align(centerY: wtgView, treatView, dotLabel)
//            
//            dotLabel.center == dotLabel.superview!.center
//            
//            wtgView.height == wtgIconSize
//            wtgView.width == wtgIconSize+labelSize+3
//            treatView.height == treatIconSize
//            treatView.width == treatIconSize+labelSize
//            
//            dotLabel.leading == wtgView.trailing - 2
//            dotLabel.trailing == treatView.leading
//            
//        }
//        constrain(wtgView) {
//            $0.leading == $0.superview!.leadingMargin
//            $0.top == $0.superview!.topMargin
//            $0.trailing == $0.superview!.trailingMargin
//            $0.bottom == $0.superview!.bottomMargin
//        }
    }
    
    // MARK: - Bindings
    
    func bindToCellData(businessInfo: BusinessInfo) {
        
//        treatTapGesture.rac_enabled <~ viewmodel.isButtonEnabled
//        wtgTapGesture.rac_enabled <~ viewmodel.isButtonEnabled
        
//        viewmodel.isTreatEnabled.producer
//            .startWithNext { [weak self] success in
//                if let this = self {
//                    
//                    this.treatImageView.rac_image <~ AssetFactory.getImage(Asset.TreatIcon(size: CGSizeMake(20, 20), backgroundColor: .x_FeaturedCardBG(), opaque: nil, imageContextScale: nil, pressed: this.viewmodel.isTreatEnabled.value, shadow: false))
//                        .take(1)
//                        .map { Optional<UIImage>($0) }
//                }
//        }
//        
//        viewmodel.isWTGEnabled.producer
//            .startWithNext { [weak self] success in
//                if let this = self {
//                    
//                    this.wtgImageView.rac_image <~ AssetFactory.getImage(Asset.WTGIcon(size: CGSizeMake(20, 20), backgroundColor: .x_FeaturedCardBG(), opaque: nil, imageContextScale: nil, pressed: this.viewmodel.isWTGEnabled.value, shadow: false))
//                        .take(1)
//                        .map { Optional<UIImage>($0) }
//                }
//        }
        
        
//        compositeDisposable += self.viewmodel.getParticipantPreview()
//            .start()
//        
//        compositeDisposable += self.viewmodel.getUserParticipation()
//            .start()
//        
//        compositeDisposable += self.viewmodel.getWTGCount()
//            .start({[weak self] _ in
//                if let this = self {
//                    this.wtgLabel.rac_text <~ this.viewmodel.wtgCount
//                }
//                })
//        
//        compositeDisposable += self.viewmodel.getTreatCount()
//            .start({[weak self] _ in
//                if let this = self {
//                    this.treatLabel.rac_text <~ this.viewmodel.treatCount
//                }
//                })
//        
//        compositeDisposable += self.viewmodel.participantViewModelArr.producer
//            .filter { $0.count > 0 }
//            .start { [weak self] event in
//                switch event {
//                case .Next(let participants):
//                    if let this = self {
//                        
//                        // iterate through previewImageViews
//                        $.each(this.previewImageViews) { index, view in
//                            if index < participants.count {
//                                
//                                // place the image into image view
//                                participants[index].avatar.producer
//                                    .ignoreNil()
//                                    .map { $0.maskWithRoundedRect(view.frame.size, cornerRadius: view.frame.size.width, backgroundColor: .x_FeaturedCardBG()) }
//                                    .startWithNext { image in
//                                        view.image = image
//                                }
//                            }
//                        }
//                    }
//                default: break
//                }
//        }
    }
    
    // MARK: - Others
    
    func initiateReuse() {
        previewImageViews.forEach { $0.image = nil }
    }
}