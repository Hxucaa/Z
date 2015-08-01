//
//  DetailParticipationTableViewCell.swift
//  XListing
//
//  Created by Lance Zhu on 2015-07-30.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import UIKit
import ReactiveCocoa

public final class DetailParticipationTableViewCell: UITableViewCell {
    
    // MARK: - UI Controls
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var countLabel: UILabel!
    
    // MARK: - Proxies
    
    // MARK: - Properties
    private var viewmodel: DetailParticipationViewModel!
    
    // MARK: - Setups
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        
        layoutMargins = UIEdgeInsetsZero
        separatorInset = UIEdgeInsetsZero
        
        // Initialization code
        
    }
    
    // MARK: - Bindings
    
    public func bindToViewModel(viewmodel: DetailParticipationViewModel) {
        self.viewmodel = viewmodel
        
        countLabel.rac_text <~ self.viewmodel.count
    }
}
