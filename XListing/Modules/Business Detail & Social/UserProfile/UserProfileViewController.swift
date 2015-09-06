//
//  UserProfileViewController.swift
//  XListing
//
//  Created by Lance Zhu on 2015-09-04.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import UIKit
import SDWebImage
import ReactiveCocoa
import Dollar
import Cartography

public final class UserProfileViewController : XUIViewController {
    
    // MARK: - UI Controls
    @IBOutlet private weak var coverImage: UIImageView!
    @IBOutlet private weak var userInfoView: UIView!
    @IBOutlet private weak var collectionView: UICollectionView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var typeLabel: UILabel!
    
    @IBOutlet weak var ageGroupView: UIView!
    
    @IBOutlet weak var constellationLabel: UILabel!
    
    @IBOutlet weak var cityLabel: UILabel!
    
    @IBOutlet weak var joinButton: UIButton!
    
    @IBOutlet weak var messageLabel: UILabel!
    
    
    // MARK: - Properties
    private var viewmodel: IUserProfileViewModel!
    private let cellIdentifier = "UserCollectionCell"
    // MARK: - Setups
    
    
    // MARK: - Bindings
    public func bindToViewModel(viewmodel: IUserProfileViewModel) {
        self.viewmodel = viewmodel
    }
    
    // MARK: - Others
    public override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        let nib = UINib(nibName: "CollectionCell", bundle: nil)
        collectionView.registerNib(nib, forCellWithReuseIdentifier: cellIdentifier)
        if let view = NSBundle.mainBundle().loadNibNamed("UserInfoView", owner: self, options: nil)[0] as? UIView{
//            view.bounds = CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, userInfoView.bounds.size.height)
            userInfoView.addSubview(view)
            constrain(view){view in
                view.top == view.superview!.top
                view.left == view.superview!.left
                view.width == view.superview!.width
                view.height == view.superview!.height
                
            }
        }
    }
}

extension UserProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    public func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellIdentifier, forIndexPath: indexPath) as? UICollectionViewCell{
            return cell
        }
        return UICollectionViewCell()
    }
    
    public func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    public func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    public func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)
    }


}
