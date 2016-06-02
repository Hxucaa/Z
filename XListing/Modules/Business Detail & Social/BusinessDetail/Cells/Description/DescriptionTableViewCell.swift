//
//  DescriptionTableViewCell.swift
//  
//
//  Created by Bruce Li on 2015-09-23.
//
//
import Foundation
import UIKit
import Cartography

final class DescriptionTableViewCell: UITableViewCell {
    
    // MARK: - UI Controls
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.opaque = true
        label.font = UIFont.systemFontOfSize(14)
        label.numberOfLines = 0
        label.sizeToFit()
        label.backgroundColor = .whiteColor()
        label.layer.masksToBounds = true
        
        return label
    }()
    
    // MARK: - Initializers
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = UITableViewCellSelectionStyle.None
        layoutMargins = UIEdgeInsetsMake(5, 15, 5, 5)
        
        contentView.addSubview(descriptionLabel)
        
        constrain(descriptionLabel) { view in
            view.leading == view.superview!.leadingMargin
            view.top == view.superview!.topMargin
            view.bottom == view.superview!.bottomMargin
            view.trailing == view.superview!.trailingMargin
        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Bindings
    
    func bindToData(descriptor: String) {
        
        descriptionLabel.text = descriptor
    }

}
