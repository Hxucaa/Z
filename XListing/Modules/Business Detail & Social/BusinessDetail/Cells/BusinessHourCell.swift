//
//  BusinessHourCell.swift
//  
//
//  Created by Bruce Li on 2015-09-27.
//
//

import Foundation
import UIKit
import Cartography
import ReactiveCocoa

public final class BusinessHourCell: UITableViewCell {

    // MARK: - UI Controls
    
    private lazy var businessHoursLabel: UILabel = {
        let label = UILabel()
        label.opaque = true
        label.font = UIFont.systemFontOfSize(14)
        label.numberOfLines = 0
        label.sizeToFit()
        
        return label
        }()
    
    // MARK: - Proxies
    private let (_expandBusinessHoursProxy, _expandBusinessHoursSink) = SimpleProxy.proxy()
    public var expandBusinessHoursProxy: SimpleProxy {
        return _expandBusinessHoursProxy
    }
    
    
    // MARK: - Properties
    
    private var viewmodel: BusinessHourCellViewModel!
    private var shouldExpand: Bool = false
    
    // MARK: - Initializers
    
    public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = UITableViewCellSelectionStyle.None
        layoutMargins = UIEdgeInsetsMake(10, 15, 10, 10)
        businessHoursLabel.text = "今天：10:30AM - 3:00PM  &  5:00PM - 11:00PM"
    
        
        let expandHoursAction = Action<UITapGestureRecognizer, Void, NoError> { [weak self] gesture in
            return SignalProducer { sink, disposable in
            if let this = self {
                if (!this.shouldExpand) {
                    this.businessHoursLabel.text = "星期一：10:30AM - 3:00PM  &  5:00PM - 11:00PM\n星期一：10:30AM - 3:00PM  &  5:00PM - 11:00PM\n星期一：10:30AM - 3:00PM  &  5:00PM - 11:00PM\n星期一：10:30AM - 3:00PM  &  5:00PM - 11:00PM\n星期一：10:30AM - 3:00PM  &  5:00PM - 11:00PM\n星期一：10:30AM - 3:00PM  &  5:00PM - 11:00PM\n星期一：10:30AM - 3:00PM  &  5:00PM - 11:00PM"
                } else {
                    this.businessHoursLabel.text = "今天：10:30AM - 3:00PM  &  5:00PM - 11:00PM"
                }
                
                this.shouldExpand = !this.shouldExpand
                sendNext(this._expandBusinessHoursSink, ())
                sendCompleted(sink)
                }
            }
        }
        let tapGesture = UITapGestureRecognizer(target: expandHoursAction.unsafeCocoaAction, action: CocoaAction.selector)
        
        
        addSubview(businessHoursLabel)
        addGestureRecognizer(tapGesture)
        
        constrain(businessHoursLabel) { view in
            view.leading == view.superview!.leadingMargin
            view.top == view.superview!.topMargin
            view.bottom == view.superview!.bottomMargin
            view.trailing == view.superview!.trailingMargin
        }
    }
    
    public required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Bindings
    
    public func bindViewModel(viewmodel: BusinessHourCellViewModel) {
        self.viewmodel = viewmodel
        //businessHoursLabel.rac_text <~ viewmodel.businessHours.producer
        //    |> takeUntilPrepareForReuse(self)
    }
}
