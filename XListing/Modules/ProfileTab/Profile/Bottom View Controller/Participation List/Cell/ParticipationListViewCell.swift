////
////  ParticipationListViewCell.swift
////  XListing
////
////  Created by Lance Zhu on 2015-10-07.
////  Copyright (c) 2016 Lance Zhu. All rights reserved.
////
//
//import Foundation
//import UIKit
//import ReactiveCocoa
//import Dollar
//import Cartography
//import XAssets
//import TZStackView
//
//private let ImageWidthRatio = CGFloat(0.27)
//private let ButtonWidthRatio = CGFloat(0.13)
//
//
//public final class ParticipationListViewCell : UITableViewCell {
//    
//    // MARK: - UI Controls
//    
//    private lazy var businessImageView: UIImageView = {
//        let width = round(self.estimatedFrame.width * ImageWidthRatio)
//        let height = self.estimatedFrame.height
//        let imageView = UIImageView(frame: CGRectMake(0, 0, width, height))
//        
//        imageView.backgroundColor = UIColor.x_ProfileTableBG()
//        imageView.image = UIImage(named: ImageAssets.businessplaceholder)
//        
//        return imageView
//    }()
//    
//    private lazy var infoPanelView: ProfileTabInfoPanelView = {
//        let width = round(self.estimatedFrame.width * ButtonWidthRatio)
//        let height = self.estimatedFrame.height
//        let infoPanel = ProfileTabInfoPanelView(frame: CGRectMake(0, 0, width, height))
//        
//        return infoPanel
//    }()
//    
//    private lazy var statusButton: StatusButton = {
//        let button = StatusButton(frame: CGRectMake(0, 0, 40, 30))
//        
//        button.setTitleColor(UIColor(red: 231.0/255, green: 144.0/255, blue: 0, alpha: 1), forState: UIControlState.Normal)
//        button.titleLabel?.font = UIFont.systemFontOfSize(14)
//        
//        return button
//    }()
//
//    private lazy var containerStackView: TZStackView = {
//        let container = TZStackView(arrangedSubviews: [self.businessImageView, self.infoPanelView, self.statusButton])
//        
//        container.distribution = TZStackViewDistribution.EqualSpacing
//        container.axis = .Horizontal
// //       container.alignment = TZStackViewAlignment.Fill
//        container.frame = CGRectMake(0, 0, self.estimatedFrame.width, self.estimatedFrame.height - 5)
//        container.opaque = true
//        container.backgroundColor = UIColor.x_ProfileTableBG()
//        container.clipsToBounds = true
//        
//        return container
//    }()
//
//    // MARK: - Properties
//    
//    private var viewmodel: IParticipationListCellViewModel! {
//        didSet {
//            infoPanelView.bindToViewModel(viewmodel.infoPanelViewModel)
//            statusButton.bindToViewModel(viewmodel.statusButtonViewModel)
//        }
//    }
//    private let estimatedFrame: CGRect
//
//    // MARK: - Initializers
//    public init(estimatedFrame: CGRect, style: UITableViewCellStyle, reuseIdentifier: String?) {
//        self.estimatedFrame = estimatedFrame
//        
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        
//        selectionStyle = UITableViewCellSelectionStyle.None
//        opaque = true
//        backgroundColor = UIColor.x_ProfileTableBG()
//        
//        /**
//        *   background container
//        */
//        contentView.addSubview(containerStackView)
//        
//        constrain(containerStackView) { view in
//            view.leading == view.superview!.leading + 10
//            view.top == view.superview!.top + 5
//            view.trailing == view.superview!.trailing - 10
//            view.bottom == view.superview!.bottom - 5
//        }
//        
//        constrain(businessImageView, infoPanelView, statusButton) {
//            $0.width == $0.superview!.width * ImageWidthRatio
//            $2.width == $2.superview!.width * ButtonWidthRatio
//        }
//        
//        infoPanelView.setContentCompressionResistancePriority(749, forAxis: .Horizontal)
//        infoPanelView.setContentHuggingPriority(751, forAxis: .Horizontal)
//    }
//    
//    public required init(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//
//    // MARK: - Bindings
//
//    public func bindToViewModel(viewmodel: IParticipationListCellViewModel) {
//        self.viewmodel = viewmodel
//        
//        businessImageView.rac_image <~ viewmodel.coverImage
//        self.viewmodel.getCoverImage()
//            .start()
//    }
//
//    // MARK: - Others
//
//}