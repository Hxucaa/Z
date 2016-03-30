//
//  FeaturedListCellNode.swift
//  XListing
//
//  Created by Lance Zhu on 2015-06-20.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import UIKit
import ReactiveCocoa
import AsyncDisplayKit

private let CARD = (INSET: (X: CGFloat(7), Y: CGFloat(4)), PLACEHOLDER: 0)
private let MAIN_CONTAINER = (INSET: CGFloat(4), PLACEHOLDER: 0)

final class FeaturedListCellNode : ASCellNode {
    
    // MARK: - UI Controls
    private let card = ASDisplayNode()
    
    private let topSection: FeaturedListCellTopSection
    private let divider = ASDisplayNode()
    private let bottomSection: FeaturedListCellBottomSection
    
    
    // MARK: - Properties
    private let businessInfo: BusinessInfo
    
    // MARK: - Initializers
    init(businessInfo: BusinessInfo) {
        self.businessInfo = businessInfo
        
        topSection = FeaturedListCellTopSection(coverImage: businessInfo.coverImageUrl, name: businessInfo.name, location: businessInfo.city)
        bottomSection = FeaturedListCellBottomSection()
        
        super.init()
        
        selectionStyle = .None
        backgroundColor = .grayColor()
        
        card.backgroundColor = .x_FeaturedCardBG()
        addSubnode(card)
        
        addSubnode(topSection)
        addSubnode(bottomSection)
        
        
        divider.backgroundColor = UIColor(hex: "D5D5D5")
        addSubnode(divider)
        
//        viewmodel.eta.producer
//            .ignoreNil()
//            .startWithNext { [weak self] text in self?.topSection.setEtaText(text) }
        
    }
    
    override func layoutSpecThatFits(constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        topSection.flexBasis = ASRelativeDimensionMakeWithPercent(0.72)
        bottomSection.flexBasis = ASRelativeDimensionMakeWithPercent(0.23)
        
        divider.sizeRange = ASRelativeSizeRange(
            min: ASRelativeSize(
                width: ASRelativeDimensionMakeWithPercent(1),
                height: ASRelativeDimensionMakeWithPoints(1)
            ),
            max: ASRelativeSize(
                width: ASRelativeDimensionMakeWithPercent(1),
                height: ASRelativeDimensionMakeWithPoints(1)
            )
        )
        
        // The outmost container
        let mainContainer = ASStackLayoutSpec(
            direction: .Vertical,
            spacing: 4.0,
            justifyContent: .Start,
            alignItems: .Start,
            children: [topSection, ASStaticLayoutSpec(children: [divider]), bottomSection]
        )
        mainContainer.sizeRange = ASRelativeSizeRange(
            min: ASRelativeSize(
                width: ASRelativeDimensionMakeWithPercent(1),
                height: ASRelativeDimension(type: .Points, value: constrainedSize.min.width * 0.5)
            ),
            max: ASRelativeSize(
                width: ASRelativeDimensionMakeWithPercent(1),
                height: ASRelativeDimension(type: .Points, value: constrainedSize.max.width * 0.5)
            )
        )
        
        return ASInsetLayoutSpec(
            insets: UIEdgeInsets(
                top: CARD.INSET.Y + MAIN_CONTAINER.INSET,
                left: CARD.INSET.X + MAIN_CONTAINER.INSET,
                bottom: CARD.INSET.Y + MAIN_CONTAINER.INSET,
                right: CARD.INSET.X + MAIN_CONTAINER.INSET
            ),
            child: ASStaticLayoutSpec(children: [mainContainer])
        )
        
    }
    
    override func didLoad() {
        super.didLoad()
    }
    
    override func layout() {
        super.layout()
        
        card.frame = CGRect(
            x: CARD.INSET.X,
            y: CARD.INSET.Y,
            width: self.calculatedSize.width - 2 * CARD.INSET.X,
            height: self.calculatedSize.height - 2 * CARD.INSET.Y
        )
    }
    
}

extension FeaturedListCellNode : ASTextNodeDelegate {
    
}

extension FeaturedListCellNode : ASNetworkImageNodeDelegate {
    
    func imageNode(imageNode: ASNetworkImageNode, didLoadImage image: UIImage) {
        setNeedsLayout()
    }
}
