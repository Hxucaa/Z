//
//  DetailAddressTableViewCell.swift
//  XListing
//
//  Created by Bruce Li on 2015-06-01.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import UIKit
import ReactiveCocoa
import Cartography
import TTTAttributedLabel

public final class DetailAddressTableViewCell: UITableViewCell {

    // MARK: - UI Controls
    private lazy var iconLabel: TTTAttributedLabel = {
        let label = TTTAttributedLabel(frame: CGRectMake(0, 0, 30, 30))
        label.backgroundColor = .whiteColor()
        label.opaque = true
        label.textColor = .blackColor()
        label.font = UIFont(name: Fonts.FontAwesome, size: 16)
        label.textAlignment = .Left
        label.text = Icons.Location.rawValue
        label.baselineAdjustment = UIBaselineAdjustment.AlignCenters
        label.userInteractionEnabled = false
        
        return label
    }()
    
    private lazy var addressLabel: TTTAttributedLabel = {
        let label = TTTAttributedLabel(frame: CGRectMake(0, 0, 300, 40))
        label.backgroundColor = .whiteColor()
        label.font = UIFont.systemFontOfSize(16)
        label.opaque = true
        label.textColor = .blackColor()
        label.textAlignment = .Left
        label.adjustsFontSizeToFitWidth = true
        label.userInteractionEnabled = false
        
        return label
    }()
    
    // MARK: - Proxies
    
    // MARK: - Properties
    private var viewmodel: DetailAddressAndMapViewModel!
    
    // MARK: - Setups
    
    public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        // Initialization code
        
        layoutMargins = UIEdgeInsetsZero
        separatorInset = UIEdgeInsetsZero
        selectionStyle = .None
        
        contentView.addSubview(iconLabel)
        contentView.addSubview(addressLabel)
        
        
        constrain(iconLabel, addressLabel) { icon, address in
            align(centerY: icon, address)
            
            icon.leading == icon.superview!.leadingMargin + 16
            icon.centerY == icon.superview!.centerY
            icon.width == 21
            
            icon.trailing == address.leading - 8
            
            address.trailing == address.superview!.trailingMargin
        }
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Bindings
    
    public func bindToViewModel(viewmodel: DetailAddressAndMapViewModel) {
        self.viewmodel = viewmodel
        
        addressLabel.rac_text <~ self.viewmodel.fullAddress.producer
            .takeUntilPrepareForReuse(self)
    }
}
