//
//  DetailBizInfoTableViewCell.swift
//  XListing
//
//  Created by Bruce Li on 2015-05-31.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import UIKit
import ReactiveCocoa

public final class DetailBizInfoTableViewCell: UITableViewCell {

    // MARK: Controls
    @IBOutlet weak var businessNameLabel: UILabel!
    @IBOutlet weak var cityAndDistanceLabel: UILabel!
    @IBOutlet weak var participateButton: UIButton!
    
    // MARK: - Proxies
//    private let (_participateProxy, _participateSink)
    
    // MARK: - Properties
    private var viewmodel: DetailBizInfoViewModel!
    private let compositeDisposable = CompositeDisposable()
    
    // MARK: - Setups
    public override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization
        let markWanttoGoAction = Action<UIButton, Void, NoError>{ [weak self] button in
            return SignalProducer { sink, disposable in
                typealias Choice = DetailBizInfoViewModel.ParticipationChoice
                if let this = self {
                    disposable += this.viewmodel.participate(Choice.我想去)
                        |> start()
                }
            }
        }
        
        participateButton.addTarget(markWanttoGoAction.unsafeCocoaAction, action: CocoaAction.selector, forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    deinit {
        compositeDisposable.dispose()
    }

    // MARK: - Bindings
    public func bindToViewModel(viewmodel: DetailBizInfoViewModel) {
        self.viewmodel = viewmodel
        
        businessNameLabel.rac_text <~ self.viewmodel.businessName
        compositeDisposable += self.viewmodel.participationButtonTitle.producer
            |> start(next: { [weak self] text in
                self?.participateButton.setTitle(text, forState: .Normal)
            })
        participateButton.rac_enabled <~ self.viewmodel.participationButtonEnabled
        cityAndDistanceLabel.rac_text <~ self.viewmodel.locationText
        
    }
}
