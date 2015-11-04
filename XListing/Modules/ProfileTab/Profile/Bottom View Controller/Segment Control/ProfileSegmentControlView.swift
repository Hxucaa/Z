//
//  ProfileSegmentControlView.swift
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
import XAssets
import Spring

private let LineView = (Height: CGFloat(3), MarginLeft: CGFloat(20), MarginRight: CGFloat(20))

public final class ProfileSegmentControlView : ButtonPageControl {
    
    // MARK: - UI Controls
    private lazy var buttonViews: [TabBarView] = {
        
        let view1 = TabBarView(frame: CGRectMake(0, 0, 200, 40))
        view1.label.text = "地方"
        view1.label.font = UIFont.boldSystemFontOfSize(18)
        view1.label.textColor = UIColor.x_PrimaryColor()
        view1.label.textColor = UIColor.x_PrimaryColor()
        
        view1.tapGestureProxy
            .startWithNext {[weak self] in
                self?.animate(toIndex: 0, duration: 1)
                self?._participationListObserver.proxyNext(())
            }
        
        
        let view2 = TabBarView(frame: CGRectMake(0, 0, 200, 40))
        view2.label.text = "相册"
        view2.label.font = UIFont.boldSystemFontOfSize(18)
        view2.label.textColor = UIColor.x_PrimaryColor()
        view2.label.textColor = UIColor.x_PrimaryColor()
        
        view2.tapGestureProxy
            .startWithNext {[weak self] in
                self?.animate(toIndex: 1, duration: 1)
                self?._photosManagerObserver.proxyNext(())
            }
        
        return [view1, view2]
    }()
    
    private var participationView: TabBarView {
        return buttonViews[0]
    }
    
    private var photoView: TabBarView {
        return buttonViews[1]
    }
    
    private lazy var lineView: SpringView = {
        let view = SpringView(frame: CGRectMake(LineView.MarginLeft, self.frame.height * 0.6, self.frame.width / CGFloat(self.buttonViews.count) - LineView.MarginLeft - LineView.MarginRight, LineView.Height))
        view.backgroundColor = UIColor.x_PrimaryColor()
        return view
    }()
    

    // MARK: - Properties
    private var selected = 0
    private var slotWidth = CGFloat(400.0)
    
    // MARK: - Proxies
    private let (_participationListProxy, _participationListObserver) = SimpleProxy.proxy()
    public var participationListProxy: SimpleProxy {
        return _participationListProxy
    }
    
    private let (_photosManagerProxy, _photosManagerObserver) = SimpleProxy.proxy()
    public var photosManagerProxy: SimpleProxy {
        return _photosManagerProxy
    }
    
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
        slotWidth = frame.size.width / CGFloat(buttonViews.count)
        buttonContainer.addArrangedSubview(participationView)
        buttonContainer.addArrangedSubview(photoView)
        
        addSubview(lineView)
    }
    
    public func animate(toIndex index: Int, duration: CGFloat){
        if selected == index {
            return
        }
        lineView.x = CGFloat(selected - index) * slotWidth
        lineView.damping = 0.7
        lineView.duration = duration
        lineView.curve = "spring"
        lineView.center = CGPointMake(CGFloat(index)*slotWidth + slotWidth/2, lineView.center.y)
        lineView.animateNext({[weak self] in
            if let this = self{
                this.selected = index
            }
        })
    }
}