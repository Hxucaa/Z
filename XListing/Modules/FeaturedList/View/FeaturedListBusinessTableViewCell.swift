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

public final class FeaturedListBusinessTableViewCell : UITableViewCell {
    
    // MARK: - UI Controls
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var businessNameLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var participationLabel: UILabel!
    @IBOutlet weak var etaLabel: UILabel!
    
    // MARK: Private Variables
    private let viewmodel = MutableProperty<FeaturedBusinessViewModel?>(nil)
    
    public override func awakeFromNib() {
        selectionStyle = UITableViewCellSelectionStyle.None
        
        layoutMargins = UIEdgeInsetsZero
        preservesSuperviewLayoutMargins = false
        
        self.viewmodel.producer
            |> ignoreNil
            |> start(next: { [unowned self] viewmodel in
                self.businessNameLabel.rac_text <~ viewmodel.businessName
                self.cityLabel.rac_text <~ viewmodel.city
                self.participationLabel.rac_text <~ viewmodel.participation
                self.etaLabel.rac_text <~ viewmodel.eta
                
                viewmodel.coverImageNSURL.producer
                    |> start(next: { url in
                        self.coverImageView.sd_setImageWithURL(url)
                    })
                })
    }
    
    public func bindViewModel(viewmodel: FeaturedBusinessViewModel) {
        self.viewmodel.put(viewmodel)
    }
}