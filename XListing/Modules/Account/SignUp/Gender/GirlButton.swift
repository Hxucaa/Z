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
import Result

@IBDesignable
public final class GirlButton : UIButton {
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        
        setImage(AssetsKit.imageOfFemaleIcon(scaleX: 1.0, scaleY: 1.0, ifPressed: false), forState: UIControlState.Normal)
        self.tintColor = UIColor.whiteColor()
        
        let tapped = Action<UIButton, Void, NoError> { button in
            return SignalProducer { observer, disposable in
                self.tintColor = AssetsKit.femaleIconFill
                observer.sendCompleted()
            }
        }
        
        addTarget(tapped.unsafeCocoaAction, action: CocoaAction.selector, forControlEvents: .TouchUpInside)
    }
}
