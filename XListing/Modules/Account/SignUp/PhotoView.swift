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
    
    // MARK: - Properties
    public let viewmodel = MutableProperty<PhotoViewModel?>(nil)
    private let compositeDisposable = CompositeDisposable()
    
    // MARK: - Proxies
    
    // MARK: - Setups
    public override func awakeFromNib() {
        super.awakeFromNib()
        
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