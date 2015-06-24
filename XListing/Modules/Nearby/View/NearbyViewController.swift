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
    
    // MARK: Actions
    private var profileButtonAction: CocoaAction!
    
    
    /// View Model
    private var viewmodel: INearbyViewModel!
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
        setupProfileButton()
        setupMapView()
    }
    
    public override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    public func bindToViewModel(viewmodel: INearbyViewModel) {
        self.viewmodel = viewmodel
    }
    
    /**
    React to Profile Button and present ProfileViewController.
    */
    private func setupProfileButton() {
        let pushProfile = Action<Void, Void, NoError> {
            return SignalProducer<Void, NoError> { [unowned self] sink, disposable in
                self.viewmodel.pushProfileModule()
                sendCompleted(sink)
            }
        }
        
        profileButtonAction = CocoaAction(pushProfile, input: ())
        
        profileButton.target = profileButtonAction
        profileButton.action = CocoaAction.selector
    }
    
    /**
    Initialize map view.
    
    */
    private func setupMapView() {
        // set the view region
        viewmodel.currentLocation
            |> start(next: { [unowned self] location in
                self.centerOnLocation(location.coordinate, animated: false)
            })
        
        // track user movement
//        mapView.setUserTrackingMode(.Follow, animated: false)
        
        // add annotation to map view
        viewmodel.businessViewModelArr.producer
            |> start(next: { [unowned self] businessArr in
                self.businessCollectionView.reloadData()
                for bus in businessArr {
                    self.mapView.addAnnotation(bus.annotation.value)
                }
            })
    }
    
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

extension NearbyViewController : MKMapViewDelegate {
    /**
    Tells the delegate that one of its annotation views was selected.
    
    :param: mapView The map view containing the annotation view.
    :param: view    The annotation view that was selected.
    */
    public func mapView(mapView: MKMapView!, didSelectAnnotationView view: MKAnnotationView!) {
        /// Scroll the Collection View to the associated business
        if let annotation = view.annotation as? MKPointAnnotation,
            index = $.findIndex(viewmodel.businessViewModelArr.value, callback: { $0.annotation.value == annotation }) {
                // Construct the index path. Note that the collection only has ONE row.
                let indexPath = NSIndexPath(forRow: NumberOfRowsInCollectionView - 1, inSection: index)
                businessCollectionView.scrollToItemAtIndexPath(indexPath, atScrollPosition: UICollectionViewScrollPosition.Left, animated: true)
                
        }
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
        centerOnLocation(annotation.coordinate, animated: true)
        
        return cell
    }
    
    /**
    Tells the delegate that the item at the specified index path was selected.
    
    :param: collectionView The collection view object that is notifying you of the selection change.
    :param: indexPath      The index path of the cell that was selected.
    */
    public func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        viewmodel.pushDetailModule(indexPath.section)
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