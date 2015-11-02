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
private let AddPhotoCellIdentifier = "AddPhotoCell"
private let MaxNumberOfPhotos = 8
public final class PhotoManagerViewController : UIViewController {
    
    // MARK: - UI Controls
    private lazy var collectionView: UICollectionView = {
        
        
        var flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSizeMake(5, 5);
        flowLayout.scrollDirection = UICollectionViewScrollDirection.Vertical
        
        let view = UICollectionView(frame: CGRect(origin: CGPointMake(0, 0), size: self.view.frame.size), collectionViewLayout: flowLayout)
        view.backgroundColor = UIColor.x_FeaturedCardBG()
        view.registerClass(ProfilePhotoCollectionViewCell.self, forCellWithReuseIdentifier: PhotoCellIdentifier)
        view.registerClass(AddPhotoCollectionViewCell.self, forCellWithReuseIdentifier: AddPhotoCellIdentifier)
        return view
    }()
    
    // MARK: - Properties
    private var viewmodel: IPhotoManagerViewModel!
    private let imagePicker = UIImagePickerController()
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
        setupImagePicker()
        
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
    
    // Present an action sheet to choose between a profile picture
    public func chooseProfilePictureSource() {
        let alert = UIAlertController(title: "选择上传方式", message: "", preferredStyle: UIAlertControllerStyle.ActionSheet)
        let galleryAction = UIAlertAction(title: "在相册中选取", style: UIAlertActionStyle.Default) { UIAlertAction -> Void in
            self.imagePicker.sourceType = .PhotoLibrary
            self.presentViewController(self.imagePicker, animated: true, completion: nil)
        }
        let cancelAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel, handler: nil)
        
        let cameraAction = UIAlertAction(title: "拍照", style: UIAlertActionStyle.Default) { UIAlertAction -> Void in
            if (!UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)) {
                let noCameraAlert = UIAlertController(title: "This device does not have a camera", message: "", preferredStyle: UIAlertControllerStyle.Alert)
                noCameraAlert.addAction(cancelAction)
                self.presentViewController(noCameraAlert, animated: true, completion: nil)
            } else {
                self.imagePicker.sourceType = .Camera
                self.presentViewController(self.imagePicker, animated: true, completion: nil)
            }
        }
        
        alert.addAction(galleryAction)
        alert.addAction(cameraAction)
        alert.addAction(cancelAction)
        presentViewController(alert, animated: true, completion: nil)
    }
    
    private func setupImagePicker() {
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
    }
}

extension PhotoManagerViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    
    public func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    public func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return min(MaxNumberOfPhotos, 9)
    }
    
    
    public func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(PhotoCellIdentifier, forIndexPath: indexPath) as! ProfilePhotoCollectionViewCell
        cell.bindToViewModel(viewmodel.profilePhotoCellViewModel)
        if indexPath.row == MaxNumberOfPhotos-1 && indexPath.row < 9 {
            let addPhotoCell = collectionView.dequeueReusableCellWithReuseIdentifier(AddPhotoCellIdentifier, forIndexPath: indexPath) as! AddPhotoCollectionViewCell
            return addPhotoCell
        }
        // Configure the cell
        return cell
    }
    
    public func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == MaxNumberOfPhotos-1 && indexPath.row < 9{
            chooseProfilePictureSource()
        }
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

// MARK: Image Picker

extension PhotoManagerViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    /**
    Tells the delegate that the user picked a still image or movie.
    
    - parameter picker: The controller object managing the image picker interface.
    - parameter info:   A dictionary containing the original image and the edited image, if an image was picked; or a filesystem URL for the movie, if a movie was picked. The dictionary also contains any relevant editing information. The keys for this dictionary are listed in Editing Information Keys.
    */
    public func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            // TO DO: ADD NEW PHOTO TO DATA ARRAY
        }
        dismissViewControllerAnimated(true, completion: nil)
        collectionView.reloadData()
    }
    
    /**
    Tells the delegate that the user cancelled the pick operation.
    
    - parameter picker: The controller object managing the image picker interface.
    */
    public func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
        collectionView.reloadData()
    }
}

