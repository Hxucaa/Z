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
import ReactiveCocoa

private let ScreenWidth = UIScreen.mainScreen().bounds.size.width

public final class DescriptionTableViewCell: UITableViewCell {

    private var viewmodel: DescriptionCellViewModel!
    
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.opaque = true
        label.font = UIFont.systemFontOfSize(14)
        label.numberOfLines = 0
        label.sizeToFit()
        
        return label
    }()
    
    public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = UITableViewCellSelectionStyle.None
        layoutMargins = UIEdgeInsetsMake(5, 15, 5, 5)
        
        descriptionLabel.text = "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book."
        addSubview(descriptionLabel)
        
        constrain(descriptionLabel) { view in
            view.leading == view.superview!.leadingMargin
            view.top == view.superview!.topMargin
            view.bottom == view.superview!.bottomMargin
            view.trailing == view.superview!.trailingMargin
        }
    }
    
    public func bindViewModel(viewmodel: DescriptionCellViewModel) {
        self.viewmodel = viewmodel
        //descriptionLabel.rac_text <~ viewmodel.description.producer
        //    |> takeUntilPrepareForReuse(self)
    }
    
    public required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
