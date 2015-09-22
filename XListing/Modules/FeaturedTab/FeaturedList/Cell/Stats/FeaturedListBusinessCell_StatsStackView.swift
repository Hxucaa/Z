//
//  FeaturedListBusinessCell_StatsStackView.swift
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

public final class FeaturedListBusinessCell_StatsStackView : TZStackView {
    
    // MARK: - UI Controls
    private func makeLabel() -> TTTAttributedLabel {
        let label = TTTAttributedLabel(frame: CGRectMake(0, 0, 40, 20))
        label.opaque = true
        label.backgroundColor = .x_FeaturedCardBG()
        label.textColor = UIColor(hex: "828282")
        label.font = UIFont.preferredFontForTextStyle(UIFontTextStyleCaption2)
        label.userInteractionEnabled = false
        label.layer.masksToBounds = true
        
        return label
    }
    
    private func makeDivider() -> UIView {
        
        let view = UIView(frame: CGRectMake(0, 0, 1, 20))
        
        view.userInteractionEnabled = false
        view.opaque = true
        view.backgroundColor = UIColor(hex: "D5D5D5")
        
        constrain(view) { view in
            view.width == 1
        }
        
        return view
    }
    
    private lazy var treatCountLabel: TTTAttributedLabel = self.makeLabel()
    private lazy var textDividerView1: UIView = self.makeDivider()
    private lazy var aaCountLabel: TTTAttributedLabel = self.makeLabel()
    private lazy var textDividerView2: UIView = self.makeDivider()
    private lazy var toGoCountLabel: TTTAttributedLabel = self.makeLabel()
    
    // MARK: - Properties
    private var viewmodel: IFeaturedListBusinessCell_StatsViewModel!
    
    // MARK: - Initializers
    
    public init() {
        super.init(arrangedSubviews: [UIView]())
        
        setup()
    }
    
    private override init(arrangedSubviews: [UIView]) {
        super.init(arrangedSubviews: [UIView]())
        
        setup()
    }
    
    public required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setups
    
    public func setup() {
        
        distribution = TZStackViewDistribution.EqualSpacing
        axis = .Horizontal
        spacing = 8
        alignment = TZStackViewAlignment.Center
        userInteractionEnabled = false
        
        addArrangedSubview(treatCountLabel)
        addArrangedSubview(textDividerView1)
        addArrangedSubview(aaCountLabel)
        addArrangedSubview(textDividerView2)
        addArrangedSubview(toGoCountLabel)
        
        constrain(textDividerView1, textDividerView2, treatCountLabel) { view1, view2, label in
            view1.height == label.height * 0.8
            view2.height == label.height * 0.8
        }
        
    }
    
    // MARK: - Bindings
    
    public func bindToViewModel(viewmodel: IFeaturedListBusinessCell_StatsViewModel) {
        self.viewmodel = viewmodel
        
        treatCountLabel.rac_text <~ self.viewmodel.treatCount
        aaCountLabel.rac_text <~ self.viewmodel.aaCount
        toGoCountLabel.rac_text <~ self.viewmodel.toGoCount
    }
    
    // MARK: - Others
}