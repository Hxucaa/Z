//
//  PublicProfileViewController.swift
//  XListing
//
//  Created by Bruce Li on 2015-10-26.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import UIKit
import ReactiveCocoa
import Cartography

private let PhotoCellIdentifier = "PhotoCell"
private let CellSize = round(UIScreen.mainScreen().bounds.width * 0.307)
private let SectionInsets = UIEdgeInsets(top: 10.0, left: 5.0, bottom: 10.0, right: 5.0)
public final class PublicProfileViewController : XUIViewController {

    
    // MARK: - UI Controls
    
    private lazy var collectionView: UICollectionView = {
        
        
        var flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSizeMake(5, 5);
        flowLayout.scrollDirection = UICollectionViewScrollDirection.Vertical
        
        let view = UICollectionView(frame: CGRect(origin: CGPointMake(0, 0), size: self.view.frame.size), collectionViewLayout: flowLayout)
        view.backgroundColor = UIColor.x_FeaturedCardBG()
        view.registerClass(ProfilePhotoCollectionViewCell.self, forCellWithReuseIdentifier: PhotoCellIdentifier)
        view.dataSource = self
        return view
        }()
    
    private let upperViewController = ProfileUpperViewController()
    
    
    // MARK: - Properties
    private var viewmodel: IPublicProfileViewModel! {
        didSet {
            upperViewController.bindToViewModel(viewmodel.profileUpperViewModel)
        }
    }
    private let compositeDisposable = CompositeDisposable()

    // MARK: - Setups
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        view.userInteractionEnabled = true
        view.opaque = true
        view.backgroundColor = UIColor.grayColor()
        
        addChildViewController(upperViewController)
        
        view.addSubview(upperViewController.view)
        view.addSubview(collectionView)
        
        upperViewController.didMoveToParentViewController(self)
        
        constrain(upperViewController.view) {
            $0.leading == $0.superview!.leading
            $0.top == $0.superview!.top
            $0.trailing == $0.superview!.trailing
            $0.height == $0.superview!.height * 0.30
        }

        constrain(upperViewController.view, collectionView) {
            $1.leading == $1.superview!.leading
            $1.top == $0.bottom
            $1.trailing == $1.superview!.trailing
            $1.bottom == $1.superview!.bottom
        }
    }
    
    public override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: false)
        navigationController?.hidesBarsOnSwipe = false
        
        // create a signal associated with `collectionView:didSelectItemAtIndexPath:` form delegate `UICollectionViewDelegate`
        // when the specified row is now selected
        compositeDisposable += rac_signalForSelector(Selector("collectionView:didSelectItemAtIndexPath:"), fromProtocol: UICollectionViewDelegate.self).toSignalProducer()
            // forwards events from producer until the view controller is going to disappear
            .takeUntilViewWillDisappear(self)
            .map { ($0 as! RACTuple).second as! NSIndexPath }
            .logLifeCycle(LogContext.FullScreenImage, signalName: "collectionView:didSelectItemAtIndexPath:")
            .startWithNext { [weak self] indexPath in
                self?.viewmodel.presentFullScreenImageModule(indexPath.row, animated: true, completion: nil)
            }
        
        collectionView.delegate = nil
        collectionView.delegate = self
    }
    
    public override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    public override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Bindings
    
    public func bindToViewModel(viewmodel: IPublicProfileViewModel) {
        self.viewmodel = viewmodel
    }
    
    // MARK: - Others
    
}

extension PublicProfileViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    
    public func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    public func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 9
    }
    
    
    public func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(PhotoCellIdentifier, forIndexPath: indexPath) as! ProfilePhotoCollectionViewCell
        cell.bindToViewModel(viewmodel.profilePhotoCellViewModel)
        return cell
    }
    
}

extension PublicProfileViewController : UICollectionViewDelegateFlowLayout {
    
    public func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
            
            return CGSize(width: CellSize, height: CellSize)
    }
    
    public func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAtIndex section: Int) -> UIEdgeInsets {
            
            return SectionInsets
    }
}
