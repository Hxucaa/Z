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
    
    // MARK: - Proxies
    private let (_navigationMapProxy, _navigationMapSink) = SignalProducer<Void, NoError>.buffer(1)
    public var navigationMapProxy: SignalProducer<Void, NoError> {
        return _navigationMapProxy
    }
    
    // MARK: - Properties
    private var viewmodel: DetailAddressAndMapViewModel!
    private let compositeDisposable = CompositeDisposable()
    
    // MARK: - Setups
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        layoutMargins = UIEdgeInsetsZero
        preservesSuperviewLayoutMargins = false
        
        setupAddressButton()
    }
    
    private func setupAddressButton() {
        
        // Action
        let pushNavMap = Action<UIButton, Void, NoError> { [weak self] button in
            return SignalProducer { sink, disposable in
                if let this = self {
                    
                    sendNext(this._navigationMapSink, ())
                    
                    sendCompleted(sink)
                }
            }
        }
        
        addressButton.addTarget(pushNavMap.unsafeCocoaAction, action: CocoaAction.selector, forControlEvents: .TouchUpInside)
    }

    public override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    deinit {
        compositeDisposable.dispose()
    }

    // MARK: Bindings
    
    public func bindToViewModel(viewmodel: DetailAddressAndMapViewModel) {
        self.viewmodel = viewmodel
        
        compositeDisposable += self.viewmodel.fullAddress.producer
            |> takeUntil(
                rac_prepareForReuseSignal.toSignalProducer()
                    |> toNihil
            )
            |> start(next: { [weak self] address in
                self?.addressButton.setTitle(address, forState: UIControlState.Normal)
            })
    }
}
