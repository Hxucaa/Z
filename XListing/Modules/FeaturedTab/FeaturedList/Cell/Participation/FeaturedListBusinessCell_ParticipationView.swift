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
                view.height == view.superview!.height
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
        let imageView = UIImageView(frame: CGRectMake(origin.x, origin.y, Preview.Width, Preview.Height))
        imageView.contentMode = UIViewContentMode.ScaleAspectFill
        imageView.backgroundColor = .x_FeaturedCardBG()
        imageView.clipsToBounds = true
                
        return imageView
    }
    
    private lazy var joinButtonContainer: UIView = {
        let viewWidth = round(self.frame.width * 0.30) - 8
        let view = UIView(frame: CGRectMake(round(self.frame.width * 0.70), 8, viewWidth, self.frame.height - 8 - 8))
        
        view.addSubview(self.joinButton)
        
        constrain(self.joinButton) { view in
            view.centerY == view.superview!.centerY
            view.leading == view.superview!.leadingMargin + 5
            view.trailing == view.superview!.trailingMargin - 5
        }
        
        return view
    }()
    
    private lazy var joinButton: UIButton = {
        let button = UIButton(frame: CGRectMake(15, 15, 50, 30))
        button.titleLabel?.frame = CGRectMake(5, 3, 15, 15)
        
//        let join = Action<UIButton, Bool, NSError>{ button in
//            return self.viewmodel.participate(ParticipationType.)
//        }
//        
//        button.addTarget(join.unsafeCocoaAction, action: CocoaAction.selector, forControlEvents: UIControlEvents.TouchUpInside)
        button.titleLabel?.opaque = true
        button.titleLabel?.backgroundColor = .x_FeaturedCardBG()
        button.titleLabel?.layer.masksToBounds = true
        button.setTitle("约起", forState: .Normal)
        button.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        button.layer.borderColor = UIColor.x_PrimaryColor().CGColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 9
        button.layer.masksToBounds = true
        button.layer.rasterizationScale = UIScreen.mainScreen().scale
        button.layer.shouldRasterize = true
        
        
        return button
    }()
    
    // MARK: - Properties
    private var viewmodel: IFeaturedListBusinessCell_ParticipationViewModel!
    private let compositeDisposable = CompositeDisposable()
    
    // MARK: - Initializers
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    public required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setups
    
    private func setup() {
        
        backgroundColor = UIColor.x_FeaturedCardBG()
        
        addSubview(participantsPreviewView)
        addSubview(joinButtonContainer)
        
        constrain(participantsPreviewView, joinButtonContainer) { container, button in
            container.leading == container.superview!.leadingMargin
            container.top == container.superview!.top
            container.width == container.superview!.width * 0.70
            container.bottom == container.superview!.bottom
            
            (button.leading == container.trailing).identifier = "joinButtonContainer leading"
            (button.top == button.superview!.topMargin).identifier = "joinButtonContainer top"
            (button.trailing == button.superview!.trailingMargin).identifier = "joinButtonContainer trailing"
            (button.bottom == button.superview!.bottomMargin).identifier = "joinButtonContainer bottom"
        }
        
    }
    
    // MARK: - Bindings
    
    public func bindToViewModel(viewmodel: IFeaturedListBusinessCell_ParticipationViewModel) {
        self.viewmodel = viewmodel
        
//        joinButton.rac_enabled <~ viewmodel.buttonEnabled.producer
//            |> takeUntilPrepareForReuse(self)
//
//        viewmodel.buttonEnabled.producer
//            |> ignoreNil
//            |> start(next: {[weak self] input in
//                    self?.joinButtonUIButton.enabled = input
//                    self?.joinButtonUIButton.hidden  = false
//                })
        
        compositeDisposable += self.viewmodel.getParticipantPreview()
            |> start()
        
        compositeDisposable += self.viewmodel.getUserParticipation()
            |> start()
        
        compositeDisposable += self.viewmodel.participantViewModelArr.producer
            |> filter { $0.count > 0 }
            |> start (next: { [weak self] participants in
                if let this = self {
                    
                    // iterate through previewImageViews
                    $.each(this.previewImageViews) { index, view in
                        if index < participants.count {
                            
                            // place the image into image view
                            participants[index].avatar.producer
                                |> ignoreNil
                                |> map { $0.maskWithRoundedRect(view.frame.size, cornerRadius: view.frame.size.width, backgroundColor: .x_FeaturedCardBG()) }
                                |> start(next: { image in
                                    view.image = image
                                })
                        }
                    }
                }
            })
    }
    
    // MARK: - Others
    
    public func initiateReuse() {
        
        $.each(previewImageViews) { index, view in
            view.image = nil
        }
    }
}