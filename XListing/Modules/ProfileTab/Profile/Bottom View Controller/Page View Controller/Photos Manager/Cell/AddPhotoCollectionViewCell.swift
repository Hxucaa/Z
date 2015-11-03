//
//  AddPhotoCollectionViewCell.swift
//  
//
//  Created by Bruce Li on 2015-10-14.
//
//

import UIKit
import Cartography
import XAssets
import ReactiveCocoa

public final class AddPhotoCollectionViewCell: UICollectionViewCell {
    
    
    private lazy var plusImageView : UIImageView = {
        let plusImage = AssetFactory.getImage(Asset.AddNewPhotoButton(size: CGSizeMake(500, 500), backgroundColor: .x_FeaturedCardBG(), opaque: nil, imageContextScale: nil, pressed: false, shadow: false))
        let imageView = UIImageView()
        imageView.rac_image <~ plusImage
            .take(1)
            .map { Optional<UIImage>($0) }
        return imageView
        }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(plusImageView)
        
        constrain(plusImageView) { view in
            view.leading == view.superview!.leading
            view.trailing == view.superview!.trailing
            view.top == view.superview!.top
            view.bottom == view.superview!.bottom
        }
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
