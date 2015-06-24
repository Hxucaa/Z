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

public final class FeaturedListBusinessTableViewCell : UITableViewCell, ReactiveTableCellView {
    
    // MARK: - UI Controls
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var businessNameLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var participationLabel: UILabel!
    
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
        
        combineLatest(self.viewmodel.city.producer, self.viewmodel.eta.producer)
            |> observeOn(UIScheduler())
            |> start(next: { [unowned self] city, eta in
                let cityNSString : NSString = city as NSString
                let cityStrSize : CGSize = cityNSString.sizeWithAttributes([NSFontAttributeName: UIFont.systemFontOfSize(12.0)])
                var etaLabel = UILabel(frame: CGRectMake(self.cityLabel.frame.origin.x + cityStrSize.width, self.cityLabel.frame.origin.y, 200, self.cityLabel.frame.height))
                etaLabel.text = eta
                etaLabel.font = etaLabel.font.fontWithSize(12.0)
                etaLabel.textColor = UIColor.darkGrayColor()
                self.addSubview(etaLabel)
            })
        
        self.viewmodel.coverImageNSURL.producer
            |> start(next: { url in
                self.coverImageView.sd_setImageWithURL(url)
            })
    }
}