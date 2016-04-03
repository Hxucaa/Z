////
////  FeaturedListCellParticipateControl.swift
////  XListing
////
////  Created by Lance Zhu on 2016-02-05.
////  Copyright © 2016 ZenChat. All rights reserved.
////
//
//import Foundation
//import UIKit
//import ReactiveCocoa
//import Result
//import AsyncDisplayKit
//
//public final class FeaturedListCellParticipateControl : ASControlNode {
//    
//    
//    // MARK: - UI Controls
//    private let participantIcon = ASImageNode()
//    private let participantStat = ASTextNode()
//    
//    
//    // MARK: - Endpoints
//    private let (_participationStatusSignal, _participationStatusObserver) = Signal<ParticipationStatus, NoError>.pipe()
//    public var participationStatusObserver: Observer<ParticipationStatus, NoError> {
//        return _participationStatusObserver
//    }
//    
//    // MARK: - Proxies
//    private let (_participateProxy, _participateObserver) = Signal<Void, NoError>.pipe()
//    public var participateProxy: Observer<Void, NoError> {
//        return _participateObserver
//    }
//    
//    // MARK: - Properties
//    private var deviceType: DeviceWidthTypeInPortrait? {
//        return UIScreen.mainScreen().deviceWidthTypeInPortrait
//    }
//    
//    
//    // MARK: - Initializers
//    public init(participateActionStatus: AnyProperty<Bool>) {
//        super.init()
//        
//        
//        hitTestSlop = UIEdgeInsets(top: -17, left: -17, bottom: -17, right: -25)
//        userInteractionEnabled = true
//        // TODO: conditionally enable action via altenative init
//        let tap = Action<ASControlNode, Void, NoError>(enabledIf: participateActionStatus) { [weak self] node in
//            SignalProducer { observer, disposable in
//                self?._participateObserver.sendNext(())
//                observer.sendCompleted()
//            }
//        }
//        addTarget(tap.unsafeCocoaAction, action: CocoaAction.selector, forControlEvents: ASControlNodeEvent.TouchUpInside)
//        
//        
//        participantIcon.image = ImageAsset.wtg
//        participantIcon.contentMode = .ScaleAspectFit
//        participantIcon.userInteractionEnabled = false
//        addSubnode(participantIcon)
//        
//        
//        participantStat.attributedString = NSAttributedString(string: "0", attributes: [
//            NSFontAttributeName: UIFont.systemFontOfSize(deviceType == .Small ? 10 : 16),
//            NSForegroundColorAttributeName: UIColor.blackColor()
//            ])
//        participantStat.maximumNumberOfLines = 1
//        participantStat.userInteractionEnabled = false
//        addSubnode(participantStat)
//        
//        _participationStatusSignal.observeNext { (t) -> () in
//            print("wtf")
//            print(t)
//        }
//    }
//    
//    public override func layoutSpecThatFits(constrainedSize: ASSizeRange) -> ASLayoutSpec {
//        
//        /**
//         *   Participate
//         */
//        
//        let stack = ASStackLayoutSpec(direction: .Horizontal, spacing: 3, justifyContent: .Start, alignItems: .Center, children: [ASStaticLayoutSpec(children: [participantIcon]), participantStat])
//        participantIcon.sizeRange = ASRelativeSizeRangeMakeWithExactRelativeSize(
//            ASRelativeSize(
//                width: ASRelativeDimensionMakeWithPoints(deviceType == .Small ? 18 : 24),
//                height: ASRelativeDimensionMakeWithPoints(deviceType == .Small ? 18 : 24)
//            )
//        )
//        
//        return ASStaticLayoutSpec(children: [stack])
//    }
//}