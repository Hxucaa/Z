////
////  FeaturedListCellBottomSection.swift
////  XListing
////
////  Created by Lance Zhu on 2016-02-04.
////  Copyright © 2016 Lance Zhu. All rights reserved.
////
//
//import Foundation
//import UIKit
//import ReactiveCocoa
//import AsyncDisplayKit
//
//private let PARTICIPANT_PREVIEW = (WIDTH: CGFloat(0.1), HEIGHT: CGFloat(0.11), SPACING: CGFloat(6))
//public enum ParticipationStatus {
//    case Joined
//    case None
//}
//
//public final class FeaturedListCellBottomSection : ASDisplayNode {
//    
//    // MARK: - UI Controls
//    private let participantPreview1 = ASNetworkImageNode(webImage: ())
//    private let participantPreview2 = ASNetworkImageNode(webImage: ())
//    private let participantPreview3 = ASNetworkImageNode(webImage: ())
//    private let participantPreview4 = ASNetworkImageNode(webImage: ())
//    private let participantPreview5 = ASNetworkImageNode(webImage: ())
//    private lazy var participantPreviews: [ASNetworkImageNode] = {
//        return [self.participantPreview1, self.participantPreview2, self.participantPreview3, self.participantPreview4, self.participantPreview5]
//    }()
//    
//    private let participateControl = FeaturedListCellParticipateControl(participateActionStatus: AnyProperty(MutableProperty<Bool>(true)))
//    
//    // MARK: - Initializers
//    public override init() {
//        
//        super.init()
//        let makeParticipantPreview = { (imageNode: ASNetworkImageNode) in
//            imageNode.delegate = self
//            imageNode.URL = NSURL(string: "https://gamerhorizon0.files.wordpress.com/2014/02/lightning-returns-final-fantasy-xiii-character-art.jpg")
//            imageNode.cornerRadius = 24
//            imageNode.imageModificationBlock = { (image: UIImage) -> UIImage in
//
//                var modifiedImage: UIImage
//                let rect = CGRectMake(0, 0, image.size.width, image.size.height)
//
//                UIGraphicsBeginImageContextWithOptions(image.size, false, UIScreen.mainScreen().scale)
//
//                UIBezierPath(roundedRect: rect, cornerRadius: 48).addClip()
//                image.drawInRect(rect)
//                modifiedImage = UIGraphicsGetImageFromCurrentImageContext()
//
//                UIGraphicsEndImageContext()
//
//                return modifiedImage
//            }
//
//            self.addSubnode(imageNode)
//        }
//        makeParticipantPreview(participantPreview1)
//        makeParticipantPreview(participantPreview2)
//        makeParticipantPreview(participantPreview3)
//        makeParticipantPreview(participantPreview4)
//        makeParticipantPreview(participantPreview5)
//        
//        participantPreview5.hidden = true
//        participantPreview4.hidden = true
//        addSubnode(participateControl)
//        
//    }
//    
//    public override func layoutSpecThatFits(constrainedSize: ASSizeRange) -> ASLayoutSpec {
//        
//        /**
//         *   Participants preview stack
//         */
//        
//        let participantPreviewsStack = ASStackLayoutSpec(
//            direction: .Horizontal,
//            spacing: PARTICIPANT_PREVIEW.SPACING,
//            justifyContent: .Start,
//            alignItems: .Center,
//            children: participantPreviews.map { ASRatioLayoutSpec(ratio: 1.04, child: $0) }
//        )
//        participantPreviewsStack.spacingBefore = 5
//        participantPreviewsStack.sizeRange = ASRelativeSizeRange(
//            min: ASRelativeSize(
//                width: ASRelativeDimensionMakeWithPercent(0.2),
//                height: ASRelativeDimensionMakeWithPercent(1)
//            ),
//            max: ASRelativeSize(
//                width: ASRelativeDimensionMakeWithPercent(0.7),
//                height: ASRelativeDimensionMakeWithPercent(1)
//            )
//        )
//
//        participateControl.flexBasis = ASRelativeDimensionMakeWithPercent(0.1)
//        
//        /**
//         *   Participation stack
//         */
//        
//        let spacer1 = ASLayoutSpec()
//        spacer1.flexGrow = true
//        
//        let spacer2 = ASLayoutSpec()
//        spacer2.flexBasis = ASRelativeDimensionMakeWithPercent(0.1)
//
//        let participationStack = ASStackLayoutSpec(direction: .Horizontal, spacing: 8.0, justifyContent: .Start, alignItems: .Center, children: [participantPreviewsStack, spacer1, ASStaticLayoutSpec(children: [participateControl]), spacer2])
//        participationStack.sizeRange = ASRelativeSizeRangeMakeWithExactRelativeSize(
//            ASRelativeSize(
//                width: ASRelativeDimensionMakeWithPercent(1),
//                height: ASRelativeDimensionMakeWithPercent(1)
//            )
//        )
//        
//        return ASStaticLayoutSpec(children: [participationStack])
//    }
//}
//
//extension FeaturedListCellBottomSection : ASTextNodeDelegate {
//    
//}
//
//extension FeaturedListCellBottomSection : ASNetworkImageNodeDelegate {
//    
//    public func imageNode(imageNode: ASNetworkImageNode, didLoadImage image: UIImage) {
//        setNeedsLayout()
//    }
//}
