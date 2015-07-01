//
//  FeaturedListBusinessTableViewCell.swift
//  XListing
//
//  Created by Lance Zhu on 2015-06-20.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import UIKit
import ReactiveCocoa

public final class FeaturedListBusinessTableViewCell : UITableViewCell, ReactiveTabelCellView {
    
    // MARK: - UI Controls
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var businessNameLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var participationLabel: UILabel!
    @IBOutlet weak var etaLabel: UILabel!
    
    
    private var viewmodel: FeaturedBusinessViewModel!
    
    public override func awakeFromNib() {
        selectionStyle = UITableViewCellSelectionStyle.None
        
        layoutMargins = UIEdgeInsetsZero
        preservesSuperviewLayoutMargins = false
        
    }
    
    public func bindViewModel(viewmodel: ReactiveTableCellViewModel) {
        self.viewmodel = viewmodel as! FeaturedBusinessViewModel
        
        businessNameLabel.rac_text <~ self.viewmodel.businessName
        cityLabel.rac_text <~ self.viewmodel.city
        participationLabel.rac_text <~ self.viewmodel.participation
        etaLabel.rac_text <~ self.viewmodel.eta
        
        self.viewmodel.coverImageNSURL.producer
            |> start(next: { url in
                self.coverImageView.sd_setImageWithURL(url)
            })
    }
}