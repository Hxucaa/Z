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
import XAssets
import ReactiveCocoa

public class ButtonPageControl : UIView {
    
    // MARK: - UI Controls
    private lazy var container: TZStackView = {
        
        let container = TZStackView(arrangedSubviews: [self.button1, self.button2])
        container.distribution = TZStackViewDistribution.FillEqually
        container.axis = .Horizontal
        container.spacing = 8
        container.alignment = .Center
        
        return container
    }()
    
    private lazy var button1: UIButton = {
        let button = UIButton()
        button.opaque = true
        
        AssetFactory.getImage(Asset.TreatIcon(size: CGSizeMake(35, 35), backgroundColor: .whiteColor(), opaque: true, imageContextScale: nil, pressed: false, shadow: false))
            |> start(
                next: { [weak button] image in
                    button?.setImage(image, forState: .Normal)
                }
            )
        
        let action = Action<UIButton, Void, NoError> { [weak self] button in
            return SignalProducer { sink, disposable in
                if let this = self {
//                    sendNext(this._editSink, ())
                }
                sendCompleted(sink)
            }
        }
        
        button.addTarget(action.unsafeCocoaAction, action: CocoaAction.selector, forControlEvents: .TouchUpInside)
        
        
        return button
    }()
    
    private lazy var button2: UIButton = {
        let button = UIButton()
        button.opaque = true
        
        AssetFactory.getImage(Asset.TreatIcon(size: CGSizeMake(35, 35), backgroundColor: .whiteColor(), opaque: true, imageContextScale: nil, pressed: false, shadow: false))
            |> start(
                next: { [weak button] image in
                    button?.setImage(image, forState: .Normal)
                }
        )
        
        let action = Action<UIButton, Void, NoError> { [weak self] button in
            return SignalProducer { sink, disposable in
                if let this = self {
                    //                    sendNext(this._editSink, ())
                }
                sendCompleted(sink)
            }
        }
        
        button.addTarget(action.unsafeCocoaAction, action: CocoaAction.selector, forControlEvents: .TouchUpInside)
        
        
        return button
    }()
//    private var buttonArray = [UIButton]()
    
    // MARK: - Proxies
    
    // MARK: - Properties
//    private var buttonCount = 0 {
//        didSet {
//            
//        }
//    }
//    
//    public var buttonImage
    
    // MARK: - Initializers
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    public required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setups
    
    private func setup() {
        addSubview(container)
        
        constrain(container) { view in
            view.leading == view.superview!.leading
            view.top == view.superview!.top
            view.trailing == view.superview!.trailing
            view.bottom == view.superview!.bottom
        }
    }
    
    // MARK: - Bindings
    
}
