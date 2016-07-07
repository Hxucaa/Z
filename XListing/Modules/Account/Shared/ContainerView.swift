//
//  ContainerView.swift
//  XListing
//
//  Created by Lance Zhu on 2015-08-14.
//  Copyright (c) 2016 Lance Zhu. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

final class ContainerView : UIView {
    
    // MARK: - UI Controls
    
    // MARK: Top Stack
    @IBOutlet private weak var _topStack: UIView!
    var topStack: UIView {
        return _topStack
    }
    @IBOutlet private weak var _backButton: UIButton!
    var backButton: UIButton {
        return _backButton
    }
    @IBOutlet private weak var _primaryLabel: UILabel!
    var primaryLabel: UILabel {
        return _primaryLabel
    }
    @IBOutlet private weak var _secondaryLabel: UILabel!
    var secondaryLabel: UILabel {
        return _secondaryLabel
    }
    
    var backButtonTap: ControlEvent<Void> {
        return _backButton.rx_tap
    }
    
    // MARK: Mid Stack
    @IBOutlet private weak var _midStack: UIView!
    var midStack: UIView {
        return _midStack
    }
    
    // MARK: Bottom Stack
    @IBOutlet private weak var _bottomStack: UIView!
    var bottomStack: UIView {
        return _bottomStack
    }
    
    // MARK: - Setups
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backButtonTap
            .subscribeNext { [weak self] in
                self?.endEditing(true)
        }
        
    }
}