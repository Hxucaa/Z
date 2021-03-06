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
import TTTAttributedLabel
import ReactiveCocoa
import TZStackView

public final class BusinessHourCell: UITableViewCell {

    // MARK: - UI Controls
    private lazy var monLabel: UILabel = {
        return self.setupLabel()
    }()
    
    private lazy var tuesLabel: UILabel = {
        return self.setupLabel()
    }()
    
    private lazy var wedsLabel: UILabel = {
        return self.setupLabel()
    }()
    
    private lazy var thursLabel: UILabel = {
        return self.setupLabel()
    }()
    
    private lazy var friLabel: UILabel = {
        return self.setupLabel()
    }()
    
    private lazy var satLabel: UILabel = {
        return self.setupLabel()
    }()
    
    private lazy var sunLabel: UILabel = {
        return self.setupLabel()
    }()
    
    
    private func setupLabel() -> UILabel {
        let label = UILabel(frame: CGRectMake(0, 0, 0, 0))
        label.opaque = true
        label.font = UIFont.systemFontOfSize(14)
        label.numberOfLines = 1
        label.sizeToFit()
        return label
    }
    
    /**
    *   MARK: Main Stack View
    */
    private lazy var mainStackView: TZStackView = {
        let container = TZStackView(arrangedSubviews: [self.monLabel, self.tuesLabel, self.wedsLabel, self.thursLabel, self.friLabel, self.satLabel, self.sunLabel])
        container.distribution = TZStackViewDistribution.EqualSpacing
        container.axis = .Vertical
        container.spacing = 15
        container.alignment = TZStackViewAlignment.Leading
        return container
    }()
    
    
    // MARK: - Proxies
    private let (_expandBusinessHoursProxy, _expandBusinessHoursObserver) = SimpleProxy.proxy()
    public var expandBusinessHoursProxy: SimpleProxy {
        return _expandBusinessHoursProxy
    }
    
    
    // MARK: - Properties
    
    private var viewmodel: BusinessHourCellViewModel!
    
    // MARK: - Initializers
    
    public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = UITableViewCellSelectionStyle.None
        layoutMargins = UIEdgeInsetsMake(10, 15, 10, 10)
        
        let expandHoursAction = Action<UITapGestureRecognizer, Void, NoError> { [weak self] gesture in
            return SignalProducer { observer, disposable in
                if let this = self {
                    this.viewmodel.switchLabelState()
                    sendNext(this._expandBusinessHoursObserver, ())
                    observer.sendCompleted()
                }
            }
        }
        let tapGesture = UITapGestureRecognizer(target: expandHoursAction.unsafeCocoaAction, action: CocoaAction.selector)

        addSubview(mainStackView)
        addGestureRecognizer(tapGesture)
        
        constrain(mainStackView) { view in
            view.leading == view.superview!.leadingMargin
            view.top == view.superview!.topMargin
            view.trailing == view.superview!.trailingMargin
            view.bottom == view.superview!.bottomMargin ~ 999
        }
    }
    
    public required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    // MARK: - Bindings
    
    public func bindViewModel(viewmodel: BusinessHourCellViewModel) {
        self.viewmodel = viewmodel
        monLabel.rac_text <~ viewmodel.monHours
        tuesLabel.rac_text <~ viewmodel.tuesHours
        wedsLabel.rac_text <~ viewmodel.wedsHours
        thursLabel.rac_text <~ viewmodel.thursHours
        friLabel.rac_text <~ viewmodel.friHours
        satLabel.rac_text <~ viewmodel.satHours
        sunLabel.rac_text <~ viewmodel.sunHours
        
        monLabel.rac_hidden <~ viewmodel.monHidden
        tuesLabel.rac_hidden <~ viewmodel.tuesHidden
        wedsLabel.rac_hidden <~ viewmodel.wedsHidden
        thursLabel.rac_hidden <~ viewmodel.thursHidden
        friLabel.rac_hidden <~ viewmodel.friHidden
        satLabel.rac_hidden <~ viewmodel.satHidden
        sunLabel.rac_hidden <~ viewmodel.sunHidden
    }
    
    
}
