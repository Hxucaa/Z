//
//  ProfilePhotoCollectionViewCell.swift
//  
//
//  Created by Bruce Li on 2015-10-13.
//
//

import UIKit
import Cartography
import ReactiveCocoa

public final class ProfilePhotoCollectionViewCell: UICollectionViewCell {
    
    
    private lazy var photo : UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    // MARK: - Properties
    private var viewmodel: ProfilePhotoCellViewModel!
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(photo)
        
        constrain(photo) { view in
            view.leading == view.superview!.leading
            view.trailing == view.superview!.trailing
            view.top == view.superview!.top
            view.bottom == view.superview!.bottom
        }
        
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    public func bindToViewModel(viewmodel: ProfilePhotoCellViewModel) {
        self.viewmodel = viewmodel
        
        photo.rac_image <~ self.viewmodel.image.producer
        
    }
    
}
