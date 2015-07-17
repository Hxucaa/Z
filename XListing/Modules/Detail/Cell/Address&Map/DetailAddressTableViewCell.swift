//
//  DetailAddressTableViewCell.swift
//  XListing
//
//  Created by Bruce Li on 2015-06-01.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import UIKit
import ReactiveCocoa

private let DetailNavigationMapViewControllerXib = "DetailNavigationMapViewController"

public final class DetailAddressTableViewCell: UITableViewCell {

    // MARK: - UI
    // MARK: Controls
    @IBOutlet weak var addressButton: UIButton!
    
    // MARK: Delegate
    internal weak var delegate: AddressAndMapDelegate!
    
    private var viewmodel: DetailAddressAndMapViewModel!
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        // Action
        let pushNavMap = Action<UIButton, Void, NoError> { button in
            return SignalProducer { sink, disposable in
                
                let navVC = DetailNavigationMapViewController(nibName: DetailNavigationMapViewControllerXib, bundle: nil)
                navVC.bindToViewModel(self.viewmodel.detailNavigationMapViewModel)
                self.delegate.pushNavigationMapViewController(navVC)
                sendCompleted(sink)
            }
        }
        
        addressButton.addTarget(pushNavMap.unsafeCocoaAction, action: CocoaAction.selector, forControlEvents: .TouchUpInside)
    }

    public override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    public func bindToViewModel(viewmodel: DetailAddressAndMapViewModel) {
        self.viewmodel = viewmodel
        addressButton.setTitle(viewmodel.fullAddress.value, forState: UIControlState.Normal)
    }
}
