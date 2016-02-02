//
//  FeaturedListCellTopSection.swift
//  XListing
//
//  Created by Lance Zhu on 2016-02-04.
//  Copyright © 2016 ZenChat. All rights reserved.
//

import Foundation
import UIKit
import AsyncDisplayKit
import WebASDKImageManager

private let DETAIL_STACK_WIDTH_FRACTION = CGFloat(0.33)
private let DETAIL_CONTENT_WIDTH_FRACTION = CGFloat(0.31)

public final class FeaturedListCellTopSection : ASDisplayNode, Component {
    
    // MARK: - UI Controls
    
    private let businessImageNode = ASNetworkImageNode(webImage: ())
    private let businessNameNode = ASTextNode()
    private let locationNode = ASTextNode()
    private let etaIcon = ASImageNode()
    private let eta = ASTextNode()
    
    // MARK: - Inputs
    public func setEtaText(text: String) {
        eta.attributedString =
            NSAttributedString(string: text, attributes: [
                NSFontAttributeName: UIFont.systemFontOfSize(deviceType == .Small ? 8 : 12),
                NSForegroundColorAttributeName: UIColor.blackColor()
            ])
        eta.invalidateCalculatedLayout()
    }
    
    // MARK: - Properties
    private var deviceType: DeviceWidthTypeInPortrait? {
        return UIScreen.mainScreen().deviceWidthTypeInPortrait
    }
    
    // MARK: - Initializers
    public init(coverImage: NSURL?, name: String, location: String) {
        super.init()
        
        businessImageNode.name = "Business Image"
        businessImageNode.backgroundColor = ASDisplayNodeDefaultPlaceholderColor()
        businessImageNode.contentMode = UIViewContentMode.ScaleAspectFill
        businessImageNode.URL = coverImage
        businessImageNode.delegate = self
        businessImageNode.layerBacked = true
        addSubnode(businessImageNode)
        
        
        businessNameNode.name = "Business Name"
        businessNameNode.attributedString = NSAttributedString(string: name, attributes: [
            NSFontAttributeName: UIFont.systemFontOfSize(deviceType == .Small ? 13 : 19),
            NSForegroundColorAttributeName: UIColor.blackColor()
            ])
        businessNameNode.flexShrink = true
        businessNameNode.maximumNumberOfLines = 2
        businessNameNode.truncationMode = NSLineBreakMode.ByCharWrapping
        addSubnode(businessNameNode)
        
        
        locationNode.name = "Business Location"
        locationNode.attributedString = NSAttributedString(string: location, attributes: [
            NSFontAttributeName: UIFont.systemFontOfSize(deviceType == .Small ? 9 : 13),
            NSForegroundColorAttributeName: UIColor.blackColor()
            ])
        locationNode.flexShrink = true
        locationNode.maximumNumberOfLines = 1
        locationNode.truncationMode = NSLineBreakMode.ByTruncatingTail
        addSubnode(locationNode)
        
        
        etaIcon.name = "ETA Icon"
        etaIcon.image = ImageAsset.distance
        etaIcon.contentMode = UIViewContentMode.ScaleAspectFill
        etaIcon.layerBacked = true
        addSubnode(etaIcon)
        
        eta.name = "ETA"
        eta.flexShrink = true
        eta.maximumNumberOfLines = 1
        eta.truncationMode = NSLineBreakMode.ByTruncatingTail
        addSubnode(eta)
        
    }
    
    public override func layoutSpecThatFits(constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        
        /**
        *   ETA
        */
        
        let etaIconStatic = ASStaticLayoutSpec(children: [etaIcon])
        etaIcon.sizeRange = ASRelativeSizeRangeMakeWithExactRelativeSize(
            ASRelativeSize(
                width: ASRelativeDimensionMakeWithPoints(deviceType == .Small ? 13 : 15),
                height: ASRelativeDimensionMakeWithPoints(deviceType == .Small ? 13 : 15)
            )
        )
        let etaTextStatic = ASStaticLayoutSpec(children: [eta])
        
        let etaStack = ASStackLayoutSpec(direction: .Horizontal, spacing: 5, justifyContent: ASStackLayoutJustifyContent.Start, alignItems: ASStackLayoutAlignItems.Center, children: [etaIconStatic, etaTextStatic])
        etaStack.spacingBefore = 70
        let etaStackStatic = ASStaticLayoutSpec(children: [etaStack])
        
        /**
        *   Business name and location
        */
        
        let businessNameAndLocationStatic = ASStaticLayoutSpec(children: [businessNameNode])
        let businessNameAndLocationStack = ASStackLayoutSpec.verticalStackLayoutSpec()
        businessNameAndLocationStack.spacing = 3
        businessNameAndLocationStack.justifyContent = .Start
        businessNameAndLocationStack.alignItems = .Start
        businessNameAndLocationStack.setChildren([businessNameAndLocationStatic, locationNode])
        businessNameAndLocationStack.sizeRange = ASRelativeSizeRange(
            min: ASRelativeSize(
                width: ASRelativeDimension(type: .Points, value: constrainedSize.min.width * DETAIL_CONTENT_WIDTH_FRACTION),
                height: ASRelativeDimension(type: .Points, value: constrainedSize.min.height * 0.3)
            ),
            max: ASRelativeSize(
                width: ASRelativeDimension(type: .Points, value: constrainedSize.min.width * DETAIL_CONTENT_WIDTH_FRACTION),
                height: ASRelativeDimension(type: .Points, value: constrainedSize.max.height * 0.6)
            )
        )
        locationNode.sizeRange = ASRelativeSizeRange(
            min: ASRelativeSize(
                width: ASRelativeDimension(
                    type: .Points,
                    value: constrainedSize.max.width * DETAIL_CONTENT_WIDTH_FRACTION),
                height: ASRelativeDimension(
                    type: .Points,
                    value: 15
                )
            ),
            max: ASRelativeSize(
                width: ASRelativeDimension(
                    type: .Points,
                    value: constrainedSize.max.width * DETAIL_CONTENT_WIDTH_FRACTION
                ),
                height: ASRelativeDimension(
                    type: .Points,
                    value: 15)
            )
        )
        businessNameNode.sizeRange = ASRelativeSizeRange(
            min: ASRelativeSize(
                width: ASRelativeDimension(
                    type: .Points,
                    value: constrainedSize.max.width * DETAIL_CONTENT_WIDTH_FRACTION),
                height: ASRelativeDimension(
                    type: .Points,
                    value: 15
                )
            ),
            max: ASRelativeSize(
                width: ASRelativeDimension(
                    type: .Points,
                    value: constrainedSize.max.width * DETAIL_CONTENT_WIDTH_FRACTION
                ),
                height: ASRelativeDimension(
                    type: .Points,
                    value: 40)
            )
        )
        
        /**
        *   Detail section
        */
        let spacer1 = ASLayoutSpec()
        spacer1.flexGrow = true
        
        let spacer2 = ASLayoutSpec()
        spacer2.flexBasis = ASRelativeDimensionMakeWithPercent(0.1)
        
        let detailStack = ASStackLayoutSpec(direction: .Vertical, spacing: 10, justifyContent: .Start, alignItems: .Start, children: [businessNameAndLocationStack, spacer1, etaStackStatic, spacer2])
        detailStack.flexBasis = ASRelativeDimensionMakeWithPercent(DETAIL_STACK_WIDTH_FRACTION)
        let detailStackStatic = ASStaticLayoutSpec(children: [detailStack])
        detailStack.sizeRange = ASRelativeSizeRange(
            min: ASRelativeSize(
                width: ASRelativeDimension(
                    type: .Points,
                    value: constrainedSize.min.width * DETAIL_STACK_WIDTH_FRACTION
                ),
                height: ASRelativeDimension(
                    type: .Points,
                    value: constrainedSize.min.height
                )
            ),
            max: ASRelativeSize(
                width: ASRelativeDimension(
                    type: .Points,
                    value: constrainedSize.max.width * DETAIL_STACK_WIDTH_FRACTION
                ),
                height: ASRelativeDimension(
                    type: .Points,
                    value: constrainedSize.max.height
                )
            )
        )
        
        
        
        businessImageNode.flexBasis = ASRelativeDimensionMakeWithPercent(0.65)
        
        // Business stack at the top
        let businessStack = ASStackLayoutSpec(direction: .Horizontal, spacing: 6.0, justifyContent: .Start, alignItems: .Center, children: [businessImageNode, detailStackStatic])
        
        
        return ASStaticLayoutSpec(children: [businessStack])
    }
}

extension FeaturedListCellTopSection : ASTextNodeDelegate {
    
}

extension FeaturedListCellTopSection : ASNetworkImageNodeDelegate {
    
    public func imageNode(imageNode: ASNetworkImageNode, didLoadImage image: UIImage) {
        setNeedsLayout()
    }
}
