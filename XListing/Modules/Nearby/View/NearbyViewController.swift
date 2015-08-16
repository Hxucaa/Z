//
//  NearbyBusinessViewController.swift
//  XListing
//
//  Created by Bruce Li on 2015-04-05.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

/**
IMPLEMENTATION DETAILS:

This view controller has a map view and a horizontal collection view. The business info is displayed as 
both annotation in the map and cell in the collection view. When swiping on the collection view,
the map view should center on the corresponding annotation. When clicking on an annotation, the collection
view should scroll to the corresponding cell.

Signal for `Selector("mapView:didAddAnnotationViews:")` implements scrolling the collection view to the
correct cell when an annotation is clicked.

There is a bug with the `UIScrollViewDelegate` that the when and where a scroll ends cannot be reliably
determined. A workaround is implemented such that when a scroll event initiates, it always call the
`Selector("scrollViewDidEndScrollingAnimation:")` where it handles centering the map on an annotation.
*/


import UIKit
import MapKit
import ReactiveCocoa
import Dollar

private let NearbyTableViewCellXIB = "NearbyTableViewCell"
private let CellIdentifier = "BusinessCell"
private let NumberOfRowsInCollectionView = 1
private let MapViewSpan = MKCoordinateSpanMake(0.07, 0.07)

public final class NearbyViewController: XUIViewController {
    
    // MARK: - UI
    // MARK: Controls
    
    @IBOutlet private weak var profileButton: UIBarButtonItem!
    @IBOutlet private weak var mapView: MKMapView!
    @IBOutlet private weak var businessCollectionView: UICollectionView!
    
    // MARK: Properties
    
    /// View Model
    private var viewmodel: INearbyViewModel!
    private let compositeDisposable = CompositeDisposable()
    
    // MARK: Setups
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.setNavigationBarHidden(false, animated: false)
        
        businessCollectionView.pagingEnabled = true
        
        setupProfileButton()
        
        // set the initial view region based on current location
        compositeDisposable += viewmodel.currentLocation
            |> logLifeCycle(LogContext.Nearby, "viewmodel.currentLocation")
            |> start(next: { [weak self] location in
                let span = MapViewSpan
                let region = MKCoordinateRegion(center: location.coordinate, span: span)
                self?.mapView.setRegion(region, animated: false)
            })
    }
    
    public override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        setupMapView()
        setupBusinessCollectionView()
        
        navigationController?.hidesBarsOnSwipe = false
    }
    
    public override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    public override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
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
        
        // track user movement
        // not tracking user movement beacause it can be a battery hog
//        mapView.setUserTrackingMode(.Follow, animated: false)
        
        // add annotation to map view
        compositeDisposable += viewmodel.businessViewModelArr.producer
            |> takeUntilViewWillDisappear(self)
            |> logLifeCycle(LogContext.Nearby, "viewmodel.businessViewModelArr.producer")
            |> start(next: { [weak self] businessArr in
                self?.businessCollectionView.reloadData()
                self?.mapView.addAnnotations(businessArr.map { $0.annotation.value })
            })
        
        
        // create a signal associated with `mapView:didAddAnnotationViews:` from delegate `MKMapViewDelegate`
        // when annotation is added to the mapview, this signal receives the next event
        compositeDisposable += rac_signalForSelector(Selector("mapView:didAddAnnotationViews:"), fromProtocol: MKMapViewDelegate.self).toSignalProducer()
            // forwards events from producer until the view controller is going to disappear
            |> takeUntilViewWillDisappear(self)
            |> map { ($0 as! RACTuple).second as! [MKAnnotationView] }
            |> logLifeCycle(LogContext.Nearby, "mapView:didAddAnnotationViews:")
            |> start(next: { [weak self] annotationViews in
                
                // iterate over annotation view and add tap gesture recognizer to each
                $.each(annotationViews, callback: { (index, view) -> () in
                    
                    // add tap gesture recognizer to annotation view
                    let tapGesture = UITapGestureRecognizer()
                    view.addGestureRecognizer(tapGesture)
                    
                    // listen to the gesture signal
                    self?.compositeDisposable += tapGesture.rac_gestureSignal().toSignalProducer()
                        // forwards events from the producer until the annotation view is prepared to be reused
                        |> takeUntilPrepareForReuse(view)
//                        |> logLifeCycle(LogContext.Nearby, "\(typeNameAndAddress(view)) tapGesture")
                        |> start(next: { _ in
                            if let this = self, mapView = self?.mapView {
                                let annotation = view.annotation
                                
                                // center the map on the annotation if it is not already in view
                                let visibleAnnotations = mapView.annotationsInMapRect(mapView.visibleMapRect)
                                if let anno = annotation as? NSObject where !visibleAnnotations.contains(anno) {
                                    mapView.setCenterCoordinate(annotation.coordinate, animated: true)
                                }
                                
                                // find the index of the business
                                let index = $.findIndex(this.viewmodel.businessViewModelArr.value) { business in
                                    if let anno = annotation as? MKPointAnnotation {
                                        return business.annotation.value == anno
                                    }
                                    else {
                                        return false
                                    }
                                }
                                
                                if let index = index {
                                    
                                    // Construct the index path. Note that the collection only has ONE row.
                                    let indexPath = NSIndexPath(forRow: NumberOfRowsInCollectionView - 1, inSection: index)
                                    
                                    // scroll to that business in the collection view.
                                    this.businessCollectionView.scrollToItemAtIndexPath(indexPath, atScrollPosition: UICollectionViewScrollPosition.Left, animated: false)
                                }
                            }
                        })
                })
            })
    }
    
    private func setupBusinessCollectionView() {
        // Observe the function `collectionView:didSelectItemAtIndexPath:` from `UICollectionViewDelegate` that the item at the specified index path was selected
        // This replaces the need to implement the function from the delegate
        compositeDisposable += rac_signalForSelector(Selector("collectionView:didSelectItemAtIndexPath:"), fromProtocol: UICollectionViewDelegate.self).toSignalProducer()
            // Completes the signal when the view controller disappears
            |> takeUntilViewWillDisappear(self)
            // Map the value obtained from signal to the desired one
            |> map { ($0 as! RACTuple).second as! NSIndexPath }
            |> logLifeCycle(LogContext.Nearby, "collectionView:didSelectItemAtIndexPath:")
            |> start(
                next: { [weak self] indexPath in
                    self?.viewmodel.pushDetailModule(indexPath.section)
                }
            )
        
        compositeDisposable += rac_signalForSelector(Selector("scrollViewDidEndScrollingAnimation:"), fromProtocol: UIScrollViewDelegate.self).toSignalProducer()
            
            // Completes the signal when the view controller disappears
            |> takeUntilViewWillDisappear(self)
            |> map { ($0 as! RACTuple).first as! UIScrollView }
            |> logLifeCycle(LogContext.Nearby, "scrollViewDidEndScrollingAnimation:")
            |> start(
                next: { [weak self] scrollView in
                    if let
                        this = self,
                        mapView = self?.mapView,
                        collectionView = scrollView as? UICollectionView,
                        visibleCells = collectionView.visibleCells() as? [UICollectionViewCell],
                        lastCell = visibleCells.last,
                        indexPath = collectionView.indexPathForCell(lastCell) {
                            // After an end scrolling is detected, we must cancel the `performSelector`, otherwise this function will get called multiple times.
                            NSObject.cancelPreviousPerformRequestsWithTarget(this)
                            
                            let business = this.viewmodel.businessViewModelArr.value[indexPath.section]
                            
                            /// Center the map to the annotation.
                            let annotation = business.annotation.value
                            
                            // Select the annotation
                            mapView.selectAnnotation(annotation, animated: true)
                            
                            // center the map on the annotation if it is not already in view
                            let visibleAnnotations = mapView.annotationsInMapRect(mapView.visibleMapRect)
                            if !visibleAnnotations.contains(annotation) {
                                mapView.setCenterCoordinate(annotation.coordinate, animated: true)
                            }
                    }
                }
            )
        
        /**
        Assigning UITableView delegate has to happen after signals are established.
        
        - tableView.delegate is assigned to self somewhere in UITableViewController designated initializer
        
        - UITableView caches presence of optional delegate methods to avoid -respondsToSelector: calls
        
        - You use -rac_signalForSelector:fromProtocol: and RAC creates method implementation for you in runtime. But UITableView knows nothing about this implementation, it still thinks that there's no such method
        
        The solution is to reassign delegate after all your -rac_signalForSelector:fromProtocol: calls:
        */
        businessCollectionView.delegate = self
    }
    
    deinit {
        compositeDisposable.dispose()
        NearbyLogVerbose("Nearby View Controller deinitializes.")
    }
    
    // MARK: Bindings
    
    public func bindToViewModel(viewmodel: INearbyViewModel) {
        self.viewmodel = viewmodel
    }
    
    // MARK: Others
}

extension NearbyViewController : UICollectionViewDataSource {
    
    
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
        
        return cell
    }
}

extension NearbyViewController : UIScrollViewDelegate {
    
    /**
    Tells the delegate when the user scrolls the content view within the receiver.
    
    :param: scrollView The scroll-view object in which the scrolling occurred.
    */
    public func scrollViewDidScroll(scrollView: UIScrollView) {
        // This is a workaround for a bug where there's no way to reliably determine when a scroll ends and its final position.
        NSObject.cancelPreviousPerformRequestsWithTarget(self)
        
        // Use the objective-C API to manually call the function indicating an end of scrolling.
        swift_performSelector("scrollViewDidEndScrollingAnimation:", withObject: scrollView, afterDelay: 0.1)
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