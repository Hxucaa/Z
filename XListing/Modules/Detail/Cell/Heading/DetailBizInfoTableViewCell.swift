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
    
    // MARK: Actions
    private var participateButtonAction: CocoaAction!
    
    internal weak var delegate: DetailBizInfoCellDelegate!
    
    private var viewmodel: DetailBizInfoViewModel!
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
        let popover = Action<Void, Void, NoError> {
            return SignalProducer { [unowned self] sink, disposable in
                self.delegate.participate(self.popover)
                sendCompleted(sink)
            }
        }
        participateButtonAction = CocoaAction(popover, input: ())
        participateButton.addTarget(participateButtonAction, action: CocoaAction.selector, forControlEvents: UIControlEvents.TouchUpInside)
    }

    public override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    public func bindToViewModel(viewmodel: DetailBizInfoViewModel) {
        self.viewmodel = viewmodel
        
        businessNameLabel.rac_text <~ self.viewmodel.businessName
        self.viewmodel.participationButtonTitle.producer
            |> start(next: { [unowned self] text in
                self.participateButton.setTitle(text, forState: .Normal)
            })
        participateButton.rac_enabled <~ self.viewmodel.participationButtonEnabled
        cityAndDistanceLabel.rac_text <~ self.viewmodel.locationText
        
    }
    
    private var popover: UIAlertController {
        typealias Choice = DetailBizInfoViewModel.ParticipationChoice
        
        var alert = UIAlertController(title: "请选一种", message: "", preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(title: Choice.我想去.rawValue, style: .Default) { alert in
            self.viewmodel.participate(Choice.我想去)
                |> start()
            })
        alert.addAction(UIAlertAction(title: Choice.我想请客.rawValue, style: .Default) { alert in
            self.viewmodel.participate(Choice.我想请客)
                |> start()
            })
        alert.addAction(UIAlertAction(title: Choice.我想AA.rawValue, style: .Default) { alert in
            self.viewmodel.participate(Choice.我想AA)
                |> start()
            })
        
        alert.addAction(UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel, handler: nil))
        
        return alert
    }
}
