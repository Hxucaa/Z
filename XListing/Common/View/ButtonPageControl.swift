//
//  ButtonPageControl.swift
//  XListing
//
//  Created by Lance Zhu on 2015-10-07.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import UIKit
import TZStackView
import Cartography
import TTTAttributedLabel
import ReactiveCocoa

public class ButtonPageControl : UIView {
    
    // MARK: - UI Controls
    public lazy var buttonContainer: TZStackView = {
        
        let container = TZStackView(arrangedSubviews: [])
        container.distribution = TZStackViewDistribution.FillEqually
        container.axis = .Horizontal
        container.spacing = 8
        container.alignment = .Center
        
        return container
    }()
    
    // MARK: - Proxies
    
    // MARK: - Properties
    
    // MARK: - Initializers
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: - Setups
    
    private func setup() {
        addSubview(buttonContainer)
        constrain(buttonContainer) { view in
            view.leading == view.superview!.leading
            view.top == view.superview!.top
            view.trailing == view.superview!.trailing
            view.bottom == view.superview!.bottom
        }
    }
    
    // MARK: - Bindings
    
}
