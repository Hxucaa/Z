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

private let sectionInsets = UIEdgeInsets(top: 10.0, left: 5.0, bottom: 10.0, right: 5.0)
private let CellSize = round(UIScreen.mainScreen().bounds.width * 0.307)
private let PhotoCellIdentifier = "PhotoCell"
public final class PhotoManagerViewController : UIViewController {
    
    // MARK: - UI Controls
    private lazy var collectionView: UICollectionView = {
        
        
        var flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSizeMake(5, 5);
        flowLayout.scrollDirection = UICollectionViewScrollDirection.Vertical
        
        let view = UICollectionView(frame: CGRect(origin: CGPointMake(0, 0), size: self.view.frame.size), collectionViewLayout: flowLayout)
        view.backgroundColor = UIColor.x_FeaturedCardBG()
        view.registerClass(ProfilePhotoCollectionViewCell.self, forCellWithReuseIdentifier: PhotoCellIdentifier)
        return view
    }()
    
    // MARK: - Properties
    private var viewmodel: IPhotoManagerViewModel!
    private let compositeDisposable = CompositeDisposable()
    
    // MARK: - Proxies
    private let (_fullImageProxy, _fullImageSink) = SimpleProxy.proxy()
    public var fullImageProxy: SimpleProxy {
        return _fullImageProxy
    }
    
    // MARK: - Initializers
    
    // MARK: - Setups
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        view.opaque = true
        
        view.addSubview(collectionView)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        constrain(collectionView) {
            $0.leading == $0.superview!.leading
            $0.top == $0.superview!.top
            $0.trailing == $0.superview!.trailing
            $0.bottom == $0.superview!.bottom
        }
        
    }
    
    public override func viewWillAppear(animated: Bool) {
        // create a signal associated with `tableView:didSelectRowAtIndexPath:` form delegate `UITableViewDelegate`
        // when the specified row is now selected
        compositeDisposable += rac_signalForSelector(Selector("collectionView:didSelectItemAtIndexPath:"), fromProtocol: UICollectionViewDelegate.self).toSignalProducer()
            // forwards events from producer until the view controller is going to disappear
            |> takeUntilViewWillDisappear(self)
            |> map { ($0 as! RACTuple).second as! NSIndexPath }
            |> logLifeCycle(LogContext.FullScreenImage, "collectionView:didSelectItemAtIndexPath:")
            |> start(
                next: { [weak self] indexPath in
                    proxyNext(self!._fullImageSink, ())
                }
        )
        
        collectionView.delegate = nil
        collectionView.delegate = self
    }
    
    // MARK: - Bindings
    
    public func bindToViewModel(viewmodel: IPhotoManagerViewModel) {
        self.viewmodel = viewmodel
    }
    
}

extension PhotoManagerViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    
    public func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    public func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 9
    }
    
    
    public func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(PhotoCellIdentifier, forIndexPath: indexPath) as! ProfilePhotoCollectionViewCell
        // Configure the cell
        return cell
    }
    
}

extension PhotoManagerViewController : UICollectionViewDelegateFlowLayout {
    
    public func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
            
            return CGSize(width: CellSize, height: CellSize)
    }
    
    public func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAtIndex section: Int) -> UIEdgeInsets {
            
            return sectionInsets
    }
}

