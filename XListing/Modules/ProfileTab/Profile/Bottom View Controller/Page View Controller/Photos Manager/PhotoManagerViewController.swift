//
//  PhotoManagerViewController.swift
//  XListing
//
//  Created by Lance Zhu on 2015-10-07.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import UIKit
import ReactiveCocoa
import AVOSCloud
import Dollar
import Cartography

public final class PhotoManagerViewController : UIViewController {
    
    // MARK: - UI Controls
    private lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: CGRect(origin: CGPointMake(0, 0), size: self.view.frame.size))
        
        return view
    }()
    
    // MARK: - Properties
    private var viewmodel: IPhotoManagerViewModel!
    
    // MARK: - Initializers
    
    // MARK: - Setups
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        view.opaque = true
        view.backgroundColor = UIColor.whiteColor()
        
        view.addSubview(collectionView)
        
        constrain(collectionView) {
            $0.leading == $0.superview!.leading
            $0.top == $0.superview!.top
            $0.trailing == $0.superview!.trailing
            $0.bottom == $0.superview!.bottom
        }
        
    }
    
    // MARK: - Bindings
    
    public func bindToViewModel(viewmodel: IPhotoManagerViewModel) {
        self.viewmodel = viewmodel
    }
}
