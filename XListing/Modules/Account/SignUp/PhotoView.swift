//
//  PhotoView.swift
//  XListing
//
//  Created by Lance Zhu on 2015-08-07.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import UIKit
import ReactiveCocoa
import Cartography

public final class PhotoView : UIView {
    
    // MARK: - UI Controls
    @IBOutlet private weak var photoImageView: UIImageView!
    private let _doneButton = RoundedButton()
    public var doneButton: RoundedButton {
        return _doneButton
    }
    
    // MARK: - Properties
    public let viewmodel = MutableProperty<PhotoViewModel?>(nil)
    private let compositeDisposable = CompositeDisposable()
    
    // MARK: - Proxies
    private let (_doneProxy, _doneSink) = SimpleProxy.proxy()
    public var doneProxy: SimpleProxy {
        return _doneProxy
    }
    
    // MARK: - Setups
    public override func awakeFromNib() {
        super.awakeFromNib()
        
        _doneButton.setTitle("完 成", forState: .Normal)
        
        
        
        /**
        Setup constraints
        */
        let group = layout(self) { view in
            view.width == self.frame.width
            view.height == self.frame.height
        }
        
        
        compositeDisposable += viewmodel.producer
            |> ignoreNil
            |> logLifeCycle(LogContext.Account, "viewmodel.producer")
            |> start(next: { [weak self] viewmodel in
                
            })
    }
    
    
    deinit {
        compositeDisposable.dispose()
        AccountLogVerbose("NicknameView deinitializes.")
    }
    
    // MARK: - Bindings
    
    // MARK: - Others
}