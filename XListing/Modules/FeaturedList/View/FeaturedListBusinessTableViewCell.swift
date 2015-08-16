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
    private var users: [User] = [User]()
    
    // MARK: Setups
    
    public override func awakeFromNib() {
        selectionStyle = UITableViewCellSelectionStyle.None
        layoutMargins = UIEdgeInsetsZero
        preservesSuperviewLayoutMargins = false
        var infoViewContent = NSBundle.mainBundle().loadNibNamed("infopanel", owner: self, options: nil)[0] as! UIView
        infoViewContent.frame = CGRectMake(0, 0, infoView.frame.width, infoView.frame.height)
        infoView.addSubview(infoViewContent)
        var participationViewContent = NSBundle.mainBundle().loadNibNamed("participationview", owner: self, options: nil)[0] as! UIView
        participationViewContent.frame = CGRectMake(0, 0, participationView.frame.width, participationView.frame.height)
        participationView.addSubview(participationViewContent)
        
        
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