//
//  ProfileHeaderView.swift
//  XListing
//
//  Created by Anson on 2015-07-21.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import UIKit
import ReactiveCocoa

public class ProfileHeaderView: UIView {
    
    // MARK: - UI Controls
    @IBOutlet private weak var topRightButton: UIButton!
    @IBOutlet private weak var topLeftButton: UIButton!
    @IBOutlet private weak var profileImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var constellationLabel: UILabel!
    @IBOutlet private weak var ageLabel: UILabel!
    @IBOutlet private weak var locationLabel: UILabel!
    
    // MARK: - Properties
    private var viewModel: ProfileHeaderViewModel!
    
    // MARK: - Proxies
    public var backProxy: SimpleProxy {
        return _backProxy
    }
    private let (_backProxy, _backSink) = SimpleProxy.proxy()
    
    public var editProxy: SimpleProxy {
        return _editProxy
    }
    private let (_editProxy, _editSink) = SimpleProxy.proxy()
    
    
    // MARK: - Actions
    private lazy var backAction: Action<UIButton, Void, NoError> = Action<UIButton, Void, NoError> { [weak self] button in
        return SignalProducer { sink, disposable in
            if let this = self {
                sendNext(this._backSink, ())
            }
            
            sendCompleted(sink)
        }
    }
    
    
    private lazy var editAction: Action<UIButton, Void, NoError> = Action<UIButton, Void, NoError> { [weak self] button in
        return SignalProducer { sink, disposable in
            if let this = self {
                sendNext(this._editSink, ())
            }
            sendCompleted(sink)
        }
    }
    
    
    // MARK: - Setups
    public override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
        topLeftButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        convertImgToCircle(self.profileImageView)
        topLeftButton.addTarget(backAction.unsafeCocoaAction, action: CocoaAction.selector, forControlEvents: .TouchUpInside)
        topRightButton.addTarget(editAction.unsafeCocoaAction, action: CocoaAction.selector, forControlEvents: .TouchUpInside)

    }
    
    // MARK: - Bindings
    public func bindViewModel(viewmodel: ProfileHeaderViewModel) {
        self.viewModel = viewmodel
        
        nameLabel.rac_text <~ viewmodel.name
        constellationLabel.rac_text <~ viewmodel.horoscope
        ageLabel.rac_text <~ viewmodel.ageGroup
        locationLabel.rac_text <~ viewmodel.district
        
        self.viewModel.coverImage.producer
            |> ignoreNil
            |> start (next: { [weak self] in
                self?.profileImageView.setImageWithAnimation($0)
            })
    }
    
    private func convertImgToCircle(imageView: UIImageView) {
        let imgWidth = CGFloat(imageView.frame.width)
        imageView.layer.cornerRadius = imgWidth / 2
        imageView.layer.masksToBounds = true;
        return
    }
}