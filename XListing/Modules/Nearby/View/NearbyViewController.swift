//
//  NearbyBusinessViewController.swift
//  XListing
//
//  Created by Bruce Li on 2015-04-05.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import UIKit
import MapKit
import ReactiveCocoa
import SDWebImage
import Dollar

private let NearbyTableViewCellXIB = "NearbyTableViewCell"
private let CellIdentifier = "BusinessCell"
private let NumberOfRowsInCollectionView = 1
private let MapViewSpan = MKCoordinateSpanMake(0.07, 0.07)

public final class NearbyViewController: XUIViewController {
    
    // MARK: - UI
    // MARK: Controls
    @IBOutlet weak var profileButton: UIBarButtonItem!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var businessCollectionView: UICollectionView!
    
    // MARK: Properties
    private var viewmodel: INearbyViewModel!
    
    // MARK: Setups
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
        setupProfileButton()
        setupMapView()
        setupBusinessCollectionView()
    }
    
    /**
    React to Profile Button and present ProfileViewController.
    */
    private func setupProfileButton() {
        let pushProfile = Action<UIBarButtonItem, Void, NoError> { [weak self] button in
            return SignalProducer<Void, NoError> { sink, disposable in
                self?.viewmodel.pushProfileModule()
                sendCompleted(sink)
            }
        }
        
        profileButton.target = pushProfile.unsafeCocoaAction
        profileButton.action = CocoaAction.selector
    }
    
    /**
    Initialize map view.
    
    */
    private func setupMapView() {
        // set the view region
        viewmodel.currentLocation
            |> start(next: { [weak self] location in
                self?.centerOnLocation(location.coordinate, animated: false)
            })
        
        // track user movement
//        mapView.setUserTrackingMode(.Follow, animated: false)
        
        // add annotation to map view
        viewmodel.businessViewModelArr.producer
            |> start(next: { [weak self] businessArr in
                self?.businessCollectionView.reloadData()
                self?.mapView.addAnnotations(businessArr.map { $0.annotation.value })
            })
        
        // Observe the function `mapView:didSelectAnnotationView:` from `MKMapViewDelegate` that one of its annotation views was selected
        // This replaces the need to implement the function from the delegate
        let didSelectAnnotationView = rac_signalForSelector(Selector("mapView:didSelectAnnotationView:"), fromProtocol: MKMapViewDelegate.self).toSignalProducer()
            // Completes the signal when the view controller disappears
            |> takeUntil(
                rac_signalForSelector(Selector("viewWillDisappear:")).toSignalProducer()
                    |> toNihil
            )
            // Map the value obtained from signal to the desired one
            |> map { ($0 as! RACTuple).second as! MKAnnotationView }
            |> start(
                next: { annotationView in
                    /// Scroll the Collection View to the associated business
                    if let annotation = annotationView.annotation as? MKPointAnnotation,
                        index = $.findIndex(self.viewmodel.businessViewModelArr.value, callback: { $0.annotation.value == annotation }) {
                            // Construct the index path. Note that the collection only has ONE row.
                            let indexPath = NSIndexPath(forRow: NumberOfRowsInCollectionView - 1, inSection: index)
                            self.businessCollectionView.scrollToItemAtIndexPath(indexPath, atScrollPosition: UICollectionViewScrollPosition.Left, animated: true)
                    }
                
                },
                completed: {
                    NearbyLogVerbose("didSelectAnnotationView signal completes.")
                }
            )
    }
    
    private func setupBusinessCollectionView() {
        // Observe the function `collectionView:didSelectItemAtIndexPath:` from `UICollectionViewDelegate` that the item at the specified index path was selected
        // This replaces the need to implement the function from the delegate
        let didSelectItemAtIndexPath = rac_signalForSelector(Selector("collectionView:didSelectItemAtIndexPath:"), fromProtocol: UICollectionViewDelegate.self).toSignalProducer()
            // Completes the signal when the view controller disappears
            |> takeUntil(
                rac_signalForSelector(Selector("viewWillDisappear:")).toSignalProducer()
                    |> toNihil
            )
            // Map the value obtained from signal to the desired one
            |> map { ($0 as! RACTuple).second as! NSIndexPath }
            |> start(
                next: { [weak self] indexPath in
                    self?.viewmodel.pushDetailModule(indexPath.section)
                },
                completed: {
                    NearbyLogVerbose("didSelectItemAtIndexPath signal completes.")
                }
            )
    }
    
    deinit {
        NearbyLogVerbose("Nearby View Controller deinitializes.")
    }
    
    // MARK: Bindings
    
    public func bindToViewModel(viewmodel: INearbyViewModel) {
        self.viewmodel = viewmodel
    }
    
    // MARK: Others
    
    /**
    Center the map to a location.
    
    :param: coordinate The coordinates.
    :param: animated   Turn on or off animation.
    */
    private func centerOnLocation(coordinate: CLLocationCoordinate2D, animated: Bool) {
        let span = MapViewSpan
        let region = MKCoordinateRegion(center: coordinate, span: span)
        mapView.setRegion(region, animated: animated)
    }
    
}

extension NearbyViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    /**
    Asks the data source for the number of sections in the collection view.
    
    :param: collectionView An object representing the collection view requesting this information.
    
    :returns: The number of sections in collectionView.
    */
    public func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return viewmodel.businessViewModelArr.value.count
    }
    
    /**
    Asks the data source for the number of items in the specified section.
    
    :param: collectionView An object representing the collection view requesting this information.
    :param: section        An index number identifying a section in collectionView. This index value is 0-based.
    
    :returns: The number of rows in section.
    */
    public func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return NumberOfRowsInCollectionView
    }
    
    /**
    Asks the data source for the cell that corresponds to the specified item in the collection view.
    
    :param: collectionView An object representing the collection view requesting this information.
    :param: indexPath      The index path that specifies the location of the item.
    
    :returns: A configured cell object. You must not return nil from this method.
    */
    public func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = businessCollectionView.dequeueReusableCellWithReuseIdentifier(CellIdentifier, forIndexPath: indexPath) as! NearbyCollectionViewCell
        let business = viewmodel.businessViewModelArr.value[indexPath.section]
        cell.bindToViewModel(business)
        
        /// Center the map to the annotation.
        let annotation = business.annotation.value
        // Select the annotation
        mapView.selectAnnotation(annotation, animated: false)
        // Center the map on the annotation
        centerOnLocation(annotation.coordinate, animated: true)
        
        return cell
    }
}

extension NearbyViewController : UICollectionViewDelegateFlowLayout {
    
    /**
    Asks the delegate for the size of the specified item’s cell.
    
    :param: collectionView       The collection view object displaying the flow layout.
    :param: collectionViewLayout The layout object requesting the information.
    :param: indexPath            The index path of the item.
    
    :returns: The width and height of the specified item. Both values must be greater than 0.
    */
    public func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return collectionView.bounds.size
    }
}