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

public final class WantToGoListViewCell : UITableViewCell, ReactiveTableCellView {
    
    // MARK: - UI Controls
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var displayName: UILabel!
    @IBOutlet weak var horoscope: UILabel!
    @IBOutlet weak var ageGroup: UILabel!
    
    // MARK: Private Variables
    private var viewmodel: WantToGoViewModel!
    
    public override func awakeFromNib() {
        profilePicture.layer.cornerRadius = profilePicture.frame.size.height / 2
        profilePicture.layer.masksToBounds = true
    }
    
    public func bindViewModel(viewmodel: ReactiveTableCellViewModel) {
        self.viewmodel = viewmodel as! WantToGoViewModel
        
        displayName.rac_text <~ self.viewmodel.displayName
        horoscope.rac_text   <~ self.viewmodel.horoscope
        ageGroup.rac_text    <~ self.viewmodel.ageGroup
        
        self.viewmodel.profilePictureNSURL.producer
            |> start(next: { url in
                if (url != "") {
                    ImageUtils.setSDWebImageWithAnimation(self.profilePicture, imageURL: url, placeholder: UIImage(named: ImageAssets.profilepicture)!)

                } else {
                    self.profilePicture.image = UIImage(named: ImageAssets.profilepicture)
                }
            })
    }
}