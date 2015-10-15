//
//  AddPhotoCollectionViewCell.swift
//  
//
//  Created by Bruce Li on 2015-10-14.
//
//

import UIKit
import Cartography

public final class AddPhotoCollectionViewCell: UICollectionViewCell {
    
    
    private lazy var photo : UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "profile"))
        return imageView
        }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(photo)
        
        constrain(photo) { view in
            view.leading == view.superview!.leading
            view.trailing == view.superview!.trailing
            view.top == view.superview!.top
            view.bottom == view.superview!.bottom
        }
    }
    
    public required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
