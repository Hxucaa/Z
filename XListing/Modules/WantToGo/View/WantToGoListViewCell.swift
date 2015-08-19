//
//  WantToGoListViewCell.swift
//  XListing
//
//  Created by William Qi on 2015-06-23.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage
import ReactiveCocoa

public final class WantToGoListViewCell : UITableViewCell {
    
    // MARK: - UI Controls
    @IBOutlet private weak var profilePicture: UIImageView!
    @IBOutlet private weak var displayName: UILabel!
    @IBOutlet private weak var horoscope: UILabel!
    @IBOutlet private weak var ageGroup: UILabel!
    
    // MARK: - Properties
    private var viewmodel: WantToGoViewModel!
    
    // MARK: - Setups
    public override func awakeFromNib() {
        profilePicture.layer.cornerRadius = profilePicture.frame.size.height / 2
        profilePicture.layer.masksToBounds = true
    }
    
    // MARK: - Bindings
    public func bindViewModel(viewmodel: WantToGoViewModel) {
        self.viewmodel = viewmodel
        
        displayName.rac_text <~ self.viewmodel.displayName
        horoscope.rac_text   <~ self.viewmodel.horoscope
        ageGroup.rac_text    <~ self.viewmodel.ageGroup
        
        self.viewmodel.profilePicture.producer
            |> takeUntilPrepareForReuse(self)
            |> ignoreNil
            |> start (next: {
                self.profilePicture.setImageWithAnimation($0)
            })
    }
}