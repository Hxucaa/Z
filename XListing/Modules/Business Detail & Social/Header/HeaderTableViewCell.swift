//
//  HeaderTableViewCell.swift
//  
//
//  Created by Bruce Li on 2015-10-01.
//
//

import UIKit
import Cartography

public final class HeaderTableViewCell: UITableViewCell {
    
    private lazy var headerLabel: UILabel = {
        let label = UILabel()
        label.opaque = true
        label.font = UIFont.systemFontOfSize(14)
        label.numberOfLines = 0
        label.sizeToFit()
        
        return label
        }()

    public func setLabelText(text: String) {
        headerLabel.text = text
    }
    
    public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = UITableViewCellSelectionStyle.None
        contentView.layoutMargins = UIEdgeInsetsMake(7, 15, 7, 5)
        
        contentView.addSubview(headerLabel)
        
        constrain(headerLabel) { view in
            view.leading == view.superview!.leadingMargin
            view.top == view.superview!.topMargin
            view.bottom == view.superview!.bottomMargin
            view.trailing == view.superview!.trailingMargin
        }
    }

    public required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


}
