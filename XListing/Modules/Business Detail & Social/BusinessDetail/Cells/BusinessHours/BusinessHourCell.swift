//
//  BusinessHourCell.swift
//  
//
//  Created by Lance Zhu on 2016-06-2.
//
//

import Foundation
import UIKit
import Cartography
import TTTAttributedLabel
import TZStackView
import RxSwift
import RxCocoa

final class BusinessHourCell: UITableViewCell {

    // MARK: - UI Controls
    private lazy var monLabel: UILabel = {
        return self.setupLabel()
        }()
    
//    private lazy var tuesLabel: UILabel = {
//        return self.setupLabel()
//        }()
//    
//    private lazy var wedsLabel: UILabel = {
//        return self.setupLabel()
//        }()
//    
//    private lazy var thursLabel: UILabel = {
//        return self.setupLabel()
//        }()
//    
//    private lazy var friLabel: UILabel = {
//        return self.setupLabel()
//        }()
//    
//    private lazy var satLabel: UILabel = {
//        return self.setupLabel()
//        }()
//    
//    private lazy var sunLabel: UILabel = {
//        return self.setupLabel()
//        }()
    /**
    *   MARK: Main Stack View
    */
    private lazy var mainStackView: TZStackView = {
//        let container = TZStackView(arrangedSubviews: [self.monLabel, self.tuesLabel, self.wedsLabel, self.thursLabel, self.friLabel, self.satLabel, self.sunLabel])
        let container = TZStackView(arrangedSubviews: [self.monLabel])
        container.distribution = TZStackViewDistribution.EqualSpacing
        container.axis = .Vertical
        container.spacing = 15
        container.alignment = TZStackViewAlignment.Leading
        return container
    }()
    
    
    // MARK: - Properties
    private let diseposeBag = DisposeBag()
    
    // MARK: - Initializers
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = UITableViewCellSelectionStyle.None
        layoutMargins = UIEdgeInsetsMake(10, 15, 10, 10)
        
        contentView.addSubview(mainStackView)
        
        constrain(mainStackView) { view in
            view.leading == view.superview!.leadingMargin
            view.top == view.superview!.topMargin
            view.trailing == view.superview!.trailingMargin
            view.bottom == view.superview!.bottomMargin ~ 999
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLabel() -> UILabel {
        let label = UILabel(frame: CGRectMake(0, 0, 0, 0))
        label.opaque = true
        label.font = UIFont.systemFontOfSize(14)
        label.numberOfLines = 1
        label.sizeToFit()
        label.backgroundColor = .whiteColor()
        label.layer.masksToBounds = true
        
        return label
    }
    
    // MARK: - Bindings
    
    func bindToData(businessHour: String) {
        monLabel.text = businessHour
    }
    
    
}
