//
//  GirlButton.swift
//  XListing
//
//  Created by Lance Zhu on 2015-08-10.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import UIKit
import XAssets
import ReactiveCocoa

@IBDesignable
public final class GirlButton : UIButton {
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        
        setImage(AssetsKit.imageOfFemaleIcon, forState: UIControlState.Normal)
        tintColor = AssetsKit.femaleIconFill
        
        let tapped = Action<UIButton, Void, NoError> { button in
            return SignalProducer { sink, disposable in
                button.selected = !button.selected
                sendCompleted(sink)
            }
        }
        
        addTarget(tapped.unsafeCocoaAction, action: CocoaAction.selector, forControlEvents: .TouchUpInside)
    }
}
