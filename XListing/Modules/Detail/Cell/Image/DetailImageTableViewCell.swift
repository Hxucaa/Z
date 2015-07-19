//
//  DetailImageTableViewCell.swift
//  XListing
//
//  Created by Bruce Li on 2015-05-31.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import UIKit
import ReactiveCocoa
import SDWebImage

public final class DetailImageTableViewCell: UITableViewCell {
    
    @IBOutlet weak var detailImageView: UIImageView!
    
    private var viewmodel: DetailImageViewModel!
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    public override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    public func bindToViewModel(viewmodel: DetailImageViewModel) {
        self.viewmodel = viewmodel
        
        
        self.viewmodel.coverImage.producer
            |> ignoreNil
            |> start (next: {
                self.detailImageView.setImageWithAnimation($0)
            })
    }
    
}
