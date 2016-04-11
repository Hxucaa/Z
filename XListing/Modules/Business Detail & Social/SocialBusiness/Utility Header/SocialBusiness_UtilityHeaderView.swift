//
//  SocialBusiness_UtilityHeaderView.swift
//  XListing
//
//  Created by Lance Zhu on 2015-09-11.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import Cartography

//private enum State {
//    case NotDetermined
//    case Participating
//    case NotParticipating
//}
//
//@IBDesignable
//class ParticipationButton : UIButton {
//
//    // MARK: - Inputs
//
//    // MARK: - Outputs
//
//    // MARK: - Properties
//    private let disposeBag = DisposeBag()
//    private static let participatingImage = UIImage(asset: .Wtg_Filled)
//    private static let notParticipatingImage = UIImage(asset: .Wtg)
//
//    // MARK: - Initializers
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//
//        setup()
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//
//        setup()
//    }
//
//    private func setup() {
//        hidden = true
//    }
//
//    // MARK: - Binding
//    func bindToData(myParticipationStatus: Driver<FeaturedListCellData.BusinessParticipation>, participate: Driver<Bool>) { // , unparticipate: Driver<Bool>
//        // TODO: implement unparticipate
//        myParticipationStatus
//            .driveNext { [weak self] in
//                switch $0 {
//                case .Participating:
//                    self?.setParticipatingState()
//                case .NotParticipating:
//                    self?.setNotParticipatingState()
//                }
//            }
//            .addDisposableTo(disposeBag)
//
//        let tapDriver = rx_tap.asDriver(onErrorJustReturn: ())
//        tapDriver
//            .flatMap { participate }
//            .filter { $0 }
//            .driveNext { [weak self] _ in
//                self?.setParticipatingState()
//            }
//            .addDisposableTo(disposeBag)
//
////        tapDriver
////            .flatMap { unparticipate }
////            .filter { $0 }
////            .driveNext { [weak self] _ in self?.setNotParticipatingState() }
////            .addDisposableTo(disposeBag)
//    }
//
//    // MARK: - Others
//
//
//    private func setNotParticipatingState() {
//        self.pin_updateUIWithImage(ParticipationButton.notParticipatingImage, animatedImage: nil)
//        hidden = false
//    }
//
//    private func setParticipatingState() {
//        self.pin_updateUIWithImage(ParticipationButton.participatingImage, animatedImage: nil)
//        hidden = false
//    }
//}

final class SocialBusiness_UtilityHeaderView : UIView {
    
    // MARK: - UI Controls
    private lazy var detailInfoButton: UIButton = {
        let button = UIButton()
        
        button.titleLabel?.opaque = true
        button.titleLabel?.layer.masksToBounds = true
        button.titleLabel?.font = UIFont.boldSystemFontOfSize(18)
        button.setTitleColor(UIColor.blackColor(), forState: .Normal)
        button.contentHorizontalAlignment = .Left
        button.backgroundColor = .whiteColor()
        button.layer.cornerRadius = 5
        
        
        let attributes = [NSForegroundColorAttributeName: UIColor.blackColor(), NSFontAttributeName: UIFont.boldSystemFontOfSize(18)]
        let attributedString = NSMutableAttributedString(string: "详细信息", attributes: attributes)
        button.setAttributedTitle(attributedString, forState: .Normal)
        button.backgroundColor = UIColor.whiteColor()
        button.titleLabel?.backgroundColor = UIColor.whiteColor()
        button.titleLabel?.textColor = UIColor.blackColor()
        
        return button
    }()
    
    private lazy var startEventButton: UIButton = {
        let button = UIButton()
        
        button.titleLabel?.opaque = true
        button.titleLabel?.backgroundColor = .whiteColor()
        button.titleLabel?.layer.masksToBounds = true
        button.titleLabel?.font = UIFont.boldSystemFontOfSize(18)
        button.setTitle("约起", forState: .Normal)
        button.setTitleColor(UIColor.x_PrimaryColor(), forState: .Normal)
        button.backgroundColor = .whiteColor()
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.x_PrimaryColor().CGColor
        
        return button
    }()
    
    // MARK: - Outputs
    var navigateToDetailPage: ControlEvent<Void> {
        return detailInfoButton.rx_tap
    }
    
    var startEvent: ControlEvent<Void> {
        return startEventButton.rx_tap
    }
    
    // MARK: - Properties
    
    // MARK: - Initializers
    init() {
        super.init(frame: CGRectMake(0, 0, 0, 0))
        setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
//    // set the button style to have a grey background and an x icon
//    func setDetailInfoButtonStyleSelected() {
//
//
//        let xAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName: UIFont(name: Fonts.FontAwesome, size: 18)!]
//        let xAttributedString = NSAttributedString(string: Icons.X.rawValue, attributes: xAttributes)
//        let attributes = [NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName: UIFont.boldSystemFontOfSize(18)]
//        let attributedString = NSMutableAttributedString(string: "  详细信息 ", attributes: attributes)
//        attributedString.appendAttributedString(xAttributedString)
//        detailInfoButton.setAttributedTitle(attributedString, forState: UIControlState.Normal)
//        detailInfoButton.backgroundColor = UIColor.grayColor()
//        detailInfoButton.titleLabel?.backgroundColor = UIColor.grayColor()
//        detailInfoButton.titleLabel?.textColor = UIColor.whiteColor()
//        
//    }
    
    // restore the button style to default white background and no x
    private func setDetailInfoButtonStyleRegular() {
    }
    
    private func disableStartEventButton(choice: EventType) {
        startEventButton.enabled = false
        startEventButton.backgroundColor = UIColor.x_PrimaryColor()
        let attributes = [NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName: UIFont.boldSystemFontOfSize(18)]
        let attributedString = NSMutableAttributedString(string: choice.description, attributes: attributes)
        startEventButton.setAttributedTitle(attributedString, forState: .Normal)
        startEventButton.titleLabel?.backgroundColor = UIColor.x_PrimaryColor()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setups
    
    private func setup() {
        backgroundColor = .whiteColor()
        opaque = true
        
        addSubview(detailInfoButton)
        addSubview(startEventButton)
        setDetailInfoButtonStyleRegular()
        
        constrain(detailInfoButton) { view in
            view.top == view.superview!.top + 12
            view.bottom == view.superview!.bottom - 12
            view.leading == view.superview!.leadingMargin + 48
            view.width == 110
        }
        
        constrain(startEventButton) { view in
            view.top == view.superview!.top + 12
            view.bottom == view.superview!.bottom - 12
            view.trailing == view.superview!.trailingMargin - 16
            view.width == 90
        }
    }
}