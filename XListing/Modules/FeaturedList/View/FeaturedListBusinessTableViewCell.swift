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

public final class FeaturedListBusinessTableViewCell : UITableViewCell {
    
    //MARK: constants
    private let avatarWidth = CGFloat(30)
    private let avatarHeight = CGFloat(30)
    private let avatarGap = CGFloat(10)
    private let avatarLeadingMargin = CGFloat(5)
    private let avatarTailingMargin = CGFloat(5)

    
    // MARK: - UI Controls
    @IBOutlet weak var businessImage: UIImageView!
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var participationView: UIView!
    @IBOutlet weak var ETAIcon: UIView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var priceLabel: PriceLabel!
    @IBOutlet weak var etaLabel: UILabel!
    
    @IBOutlet weak var peopleWantogoLabel: UILabel!
    @IBOutlet weak var avatarList: UIView!
    @IBOutlet weak var joinButton: UIButton!
    
    // MARK: Properties

    private var viewmodel: FeaturedBusinessViewModel!
    private let compositeDisposable = CompositeDisposable()
    /// whether this instance of cell has been reused
    private let isReusedCell = MutableProperty<Bool>(false)
    private var users: [User] = [User]()
    private var btnNormalImage = UIImage()
    private var btnDisabledImage = UIImage()
    
    // MARK: Setups
    
    public override func awakeFromNib() {
        selectionStyle = UITableViewCellSelectionStyle.None
        layoutMargins = UIEdgeInsetsZero
        preservesSuperviewLayoutMargins = false

        var infoViewContent = NSBundle.mainBundle().loadNibNamed("infopanel", owner: self, options: nil)[0] as! UIView
        infoView.addSubview(infoViewContent)
        
        
        var participationViewContent = NSBundle.mainBundle().loadNibNamed("participationview", owner: self, options: nil)[0] as! UIView
        participationView.addSubview(participationViewContent)
        
        //Set anchor size for all related views
        
        layout(businessImage) { businessImage in
            
            //sizes
            businessImage.width == businessImage.superview!.width * 0.544
            businessImage.height == businessImage.width * 0.6078
        }
        
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
        
        let join = Action<UIButton, Bool, NSError>{ button in
            return self.viewmodel.participate(ParticipationChoice.我想去)
        }
        joinButton.addTarget(join.unsafeCocoaAction, action: CocoaAction.selector, forControlEvents: UIControlEvents.TouchUpInside)
        
        /**
        *  When the cell is prepared for reuse, set the state.
        *
        */
        compositeDisposable += rac_prepareForReuseSignal.toSignalProducer()
            |> start(next: { [weak self] _ in
                self?.isReusedCell.put(true)
            })
        
//        UIGraphicsBeginImageContextWithOptions(CGSizeMake(30, 30), false, CGFloat(1))
//        AssetsKit.drawWTGButtonUntapped(scale: 0.2)
//        self.btnNormalImage = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//        
//        UIGraphicsBeginImageContextWithOptions(CGSizeMake(30, 30), false, CGFloat(1))
//        AssetsKit.drawWTGButtonTapped(scale: 0.2)
//        self.btnDisabledImage = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
        
        self.btnNormalImage = AssetsKit.imageOfWTGButtonUntapped(scale: 1)
        self.btnDisabledImage = AssetsKit.imageOfWTGButtonTapped(scale: 1)
        joinButton.setBackgroundImage(self.btnNormalImage, forState: UIControlState.Normal)
        joinButton.setBackgroundImage(self.btnDisabledImage, forState: UIControlState.Disabled)
        
    }
    
    deinit {
        compositeDisposable.dispose()
    }

    
    // MARK: Bindings
    
    public func bindViewModel(viewmodel: FeaturedBusinessViewModel) {
        self.viewmodel = viewmodel
        
        self.joinButton.rac_enabled <~ viewmodel.buttonEnabled.producer
        self.nameLabel.rac_text <~ viewmodel.businessName.producer
           |> takeUntilPrepareForReuse(self)
        self.cityLabel.rac_text <~ viewmodel.city.producer
            |> takeUntilPrepareForReuse(self)
//        self.priceLabel.rac_text <~ viewmodel.price.producer
//            |> takeUntilPrepareForReuse(self)
        compositeDisposable += viewmodel.price.producer
            |> start(next: { [weak self] price in
                self!.priceLabel.setPriceLabel(price)
                self!.priceLabel.setNeedsDisplay()
            })
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
        
        compositeDisposable += self.viewmodel.userArr.producer
            |> start (next: { [weak self] users in
                self?.users = users
                self?.setupParticipationView(users)
            })
    }
    
    
    private func setupParticipationView(users: [User]){
//        FeaturedLogDebug("setup count of users: \(users.count)")
        
        var count = Int(floor((self.avatarList.frame.width - self.avatarLeadingMargin - self.avatarTailingMargin - self.avatarWidth)/(self.avatarWidth + self.avatarGap))) + 1
        var hasMoreUsers = users.count > count

//        FeaturedLogDebug("count: \(count)")
//        FeaturedLogDebug("hasMoreusers: \(hasMoreUsers)")
        
        var images = [UIImage]()
        var imageViews = [UIImageView]()
        
        // populate images
        for (var i = 0; i<users.count && i<count; i++){
            let user = users[i]
            if let image = user.profileImg{
                let data = image.getData()
                if let uiImage = UIImage(data: data){
                    images.append(uiImage)
                }
            }
        }
        
        if hasMoreUsers && images.count > 0{
            if let image = UIImage(named: "downArrow"){
                images[images.count-1] = image
            }
        }
        
        // populate imageViews
        
        for i in 0...count-1{
            let x = self.avatarLeadingMargin + CGFloat(i)*(self.avatarWidth + self.avatarGap)
            let y = (self.avatarList.frame.height - self.avatarHeight)/CGFloat(2.0)
            let frame = CGRectMake(x, y, self.avatarWidth, self.avatarHeight)
            let imageView = UIImageView(frame: frame)
            if i<images.count{
                let image = images[i]
                imageView.setImageWithAnimation(image)
                imageView.toCircle()
                self.avatarList.addSubview(imageView)
            }
        }
    }
}