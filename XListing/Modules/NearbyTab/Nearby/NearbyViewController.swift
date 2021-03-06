//
//  NearbyBusinessViewController.swift
//  XListing
//
//  Created by Lance Zhu on 2016-01-25.
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
import ReactiveArray
import Dollar

private let NearbyTableViewCellXIB = "NearbyTableViewCell"
private let CellIdentifier = "BusinessCell"
private let NumberOfRowsInCollectionView = 1
private let MapViewSpan = MKCoordinateSpanMake(0.07, 0.07)

public final class NearbyViewController: XUIViewController, MKMapViewDelegate {
    
    // MARK: - UI
    // MARK: Controls
    @IBOutlet private weak var mapView: MKMapView!
    @IBOutlet private weak var currentLocationButton: UIButton!
    @IBOutlet private weak var businessCollectionView: UICollectionView!
    @IBOutlet private weak var redoSearchButton: UIButton!
    
    // MARK: Properties
    
    /// View Model
    private var viewmodel: INearbyViewModel!
    private let compositeDisposable = CompositeDisposable()
    
    // MARK: Setups
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.barTintColor = UIColor.x_PrimaryColor()
        navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        navigationController?.navigationBar.barStyle = UIBarStyle.Black

        businessCollectionView.pagingEnabled = true
        
        setupCurrentLocationButton()
        setupRedoSearchButton()
        
        compositeDisposable += viewmodel.currentLocation
            .takeUntilViewWillDisappear(self)
            .logLifeCycle(LogContext.Nearby, signalName: "viewmodel.currentLocation")
            .on(next: { [weak self] location in
                // set the initial view region based on current location
                self?.mapView.setRegion(MKCoordinateRegion(center: location.coordinate, span: MapViewSpan), animated: false) }
            )
            .flatMap(FlattenStrategy.Latest) {
                // get more businesses based on current location
                self.viewmodel.getAdditionalBusinesses($0)
                    .logLifeCycle(LogContext.Nearby, signalName: "viewmodel.getAdditionalBusinesses")
            }
            .start()
    }
    
    
    public override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // observing collection data source
        compositeDisposable += viewmodel.collectionDataSource.producer
            .takeUntilViewWillDisappear(self)
            .logLifeCycle(LogContext.Nearby, signalName: "viewmodel.collectionDataSource.producer")
            .start(
                { [weak self] event in
                    if let this = self {
                        switch event {
                        case .Next(let operation):
                            switch operation {
                            case let .Initiate(values):
                                zip(values.map { $0.annotation.producer })
                                    .startWithNext { this.mapView.addAnnotations($0) }
                                this.businessCollectionView.reloadData()
                                
                            case .AppendContentsOf(let values):
                                zip(values.map { $0.annotation.producer })
                                    .startWithNext { this.mapView.addAnnotations($0) }
                                let sections = this.businessCollectionView.numberOfSections()
                                
                                // manually insert sections to collection view.
                                this.businessCollectionView.insertSections(NSIndexSet(indexesInRange: NSMakeRange(sections, values.count)))
                                
                            case let .ReplaceAll(values):
                                guard let firstValue = values.first else {
                                    break
                                }
                                
                                this.businessCollectionView.reloadData()
                                
                                zip(values.map { $0.annotation.producer })
                                    .startWithNext { this.mapView.addAnnotations($0) }
                                //                                    this.mapView.addAnnotations(values.map
                                
                                // get the first result
                                firstValue.annotation.producer
                                    .startWithNext { firstAnnotation in
                                        
                                        // select and centre the map on the first result
                                        this.mapView.selectAnnotation(firstAnnotation, animated: true)
                                        this.mapView.setCenterCoordinate(firstAnnotation.coordinate, animated: true)
                                        
                                        // scroll the collection view to match
                                        let indexPath = NSIndexPath(forRow: 0, inSection: 0)
                                        this.businessCollectionView.scrollToItemAtIndexPath(indexPath, atScrollPosition: UICollectionViewScrollPosition.Left, animated: false)
                                    }
                                
                            default:
                                this.businessCollectionView.reloadData()
                                assertionFailure("Unexpected case during changes to Nearby business collection array")
                            }
                        default: break
                        }
                        
                    }
                }
        )
        
        
        
        setupMapView()
        setupBusinessCollectionView()
    }
    
    public override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    public override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    /**
    React to Current Location Button and centre the map on the user location
    */
    private func setupCurrentLocationButton() {
        
        // Set the button icon
        currentLocationButton.setAttributedTitle(NSAttributedString(string: Icons.Location.rawValue), forState: UIControlState.Normal)
        
        // make the button a circle shape
        currentLocationButton.layer.cornerRadius = CGFloat(currentLocationButton.frame.width) / 2
        currentLocationButton.layer.masksToBounds = true
        
        let centreCurrentLocation = Action<UIButton, Void, NoError> { [weak self] button in
            return SignalProducer<Void, NoError> { observer, disposable in
                if let this = self {
                    this.mapView.setCenterCoordinate(this.mapView.userLocation.coordinate, animated: true)
                }
                observer.sendCompleted()
            }
        }
        
        currentLocationButton.addTarget(centreCurrentLocation.unsafeCocoaAction, action: CocoaAction.selector, forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    private func setupRedoSearchButton() {
        
        redoSearchButton.hidden = true
        
        // round the button corners
        redoSearchButton.layer.cornerRadius = 8
        redoSearchButton.layer.masksToBounds = true
        
        let reQueryMapAction = Action<UIButton, Void, NSError> { [weak self] button in
            return SignalProducer { observer, disposable in
                if let this = self {
                    
                    let latDelta = this.mapView.region.span.latitudeDelta
                    let longDelta = this.mapView.region.span.longitudeDelta
                    let mapCentreLat = this.mapView.region.center.latitude
                    let mapCentreLong = this.mapView.region.center.longitude
                    
                    // get the coordinates of the north east corner of the map
                    let neLat = mapCentreLat - latDelta/2
                    let neLong = mapCentreLong + longDelta/2
                    let cornerCoordinate = CLLocation(latitude: neLat, longitude: neLong)
                    
                    // get the coordinates of the centre location of the map
                    let centreLocation = CLLocation(latitude: mapCentreLat, longitude: mapCentreLong)
                    
                    // get the number of km between the centre and the corner to form the search radius
                    let radiusOfMapInKm = centreLocation.distanceFromLocation(cornerCoordinate) / 1000
                    
                    // start the query
                    disposable += this.viewmodel.getBusinessesWithMap(centreLocation, radius: radiusOfMapInKm)
                        .start { event in
                            switch event {
                            case .Completed:
                                self?.redoSearchButton.hidden = true
                                // clear the map of the previous pins
                                this.mapView.removeAnnotations(this.mapView.annotations)
                                
                                observer.sendCompleted()
                                break
                            default: break
                            }
                        }
                }
            }
        }
        
        redoSearchButton.addTarget(reQueryMapAction.unsafeCocoaAction, action: CocoaAction.selector, forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    /**
    Initialize map view.
    */
    private func setupMapView() {
        
        // track user movement
        // not tracking user movement beacause it can be a battery hog
        //        mapView.setUserTrackingMode(.Follow, animated: false)
        
        compositeDisposable += rac_signalForSelector(Selector("mapView:didSelectAnnotationView:"), fromProtocol: MKMapViewDelegate.self).toSignalProducer()
            .takeUntilViewWillDisappear(self)
            .logLifeCycle(LogContext.Nearby, signalName: "mapView:didAddAnnotationViews:")
            .map { (($0 as! RACTuple).second as! MKAnnotationView).annotation }
            .ignoreNil()
            // find annotation that matches the selected annotation
            // then map its index in collection data source
            .map { selectedAnnotation in
                $.findIndex(self.viewmodel.collectionDataSource.array.map { $0.annotation.value }) { $0 === selectedAnnotation }
            }
            .ignoreNil()
            // map to index path
            .map { NSIndexPath(forRow: NumberOfRowsInCollectionView - 1, inSection: $0) }
            // scroll collection view to match the business on selected annotation
            .startWithNext { self.businessCollectionView.scrollToItemAtIndexPath($0, atScrollPosition: .Left, animated: false) }
        
        var mapChangedFromUserInteraction = false
        
        /**
        *   Workaround for the lack API of determine whether the movement of the view map is triggered by user touch event.
        */
        
        compositeDisposable += rac_signalForSelector(Selector("mapView:regionWillChangeAnimated:"), fromProtocol: MKMapViewDelegate.self).toSignalProducer()
            // Completes the signal when the view controller disappears
            .takeUntilViewWillDisappear(self)
            .map { ($0 as! RACTuple).second as! Bool }
            .logLifeCycle(LogContext.Nearby, signalName: "mapView:regionWillChangeAnimated:")
            .startWithNext { [weak self] _ in
                /// Determine whether the region change is triggered by user interaction.
                /// Note that this implementation depends on the internal impelmentation MKMapView by Apple, which could break at later versions.
                mapChangedFromUserInteraction = { () -> Bool in
                    
                    //  Look through gesture recognizers to determine whether this region change is from user interaction
                    if let view = self?.mapView.subviews.first as UIView!, gestureRecognizers = view.gestureRecognizers {
                        for recognizer in gestureRecognizers {
                            if recognizer.state == UIGestureRecognizerState.Began || recognizer.state == UIGestureRecognizerState.Ended {
                                return true
                            }
                        }
                    }
                    return false
                }()
                
                if mapChangedFromUserInteraction {
                    // show the redo search button when user moves the map
                    self?.redoSearchButton.hidden = false
                }
            }
        
        compositeDisposable += rac_signalForSelector(Selector("mapView:regionDidChangeAnimated:"), fromProtocol: MKMapViewDelegate.self).toSignalProducer()
            // Completes the signal when the view controller disappears
            .takeUntilViewWillDisappear(self)
            .map { ($0 as! RACTuple).second as! Bool }
            .logLifeCycle(LogContext.Nearby, signalName: "mapView:regionDidChangeAnimated:")
            .startWithNext { [weak self] _ in
                if mapChangedFromUserInteraction {
                    // show the redo search button when user moves the map
                    self?.redoSearchButton.hidden = false
                }
            }
        
        
        /**
        Assigning MKMapView delegate has to happen after signals are established.
        
        - mapView.delegate is assigned to self somewhere in MKMapView designated initializer
        
        - MKMapView caches presence of optional delegate methods to avoid -respondsToSelector: calls
        
        - You use -rac_signalForSelector:fromProtocol: and RAC creates method implementation for you in runtime. But MKMapView knows nothing about this implementation, it still thinks that there's no such method
        
        The solution is to reassign delegate after all your -rac_signalForSelector:fromProtocol: calls:
        */
        mapView.delegate = nil
        mapView.delegate = self
    }
    
    private func setupBusinessCollectionView() {
        // Observe the function `collectionView:didSelectItemAtIndexPath:` from `UICollectionViewDelegate` that the item at the specified index path was selected
        // This replaces the need to implement the function from the delegate
        compositeDisposable += rac_signalForSelector(Selector("collectionView:didSelectItemAtIndexPath:"), fromProtocol: UICollectionViewDelegate.self).toSignalProducer()
            // Completes the signal when the view controller disappears
            .takeUntilViewWillDisappear(self)
            // Map the value obtained from signal to the desired one
            .map { ($0 as! RACTuple).second as! NSIndexPath }
            .logLifeCycle(LogContext.Nearby, signalName: "collectionView:didSelectItemAtIndexPath:")
            .startWithNext { [weak self] indexPath in
                self?.viewmodel.pushSocialBusinessModule(indexPath.section)
            }
        
        compositeDisposable += rac_signalForSelector(Selector("scrollViewDidEndScrollingAnimation:"), fromProtocol: UIScrollViewDelegate.self).toSignalProducer()
            
            // Completes the signal when the view controller disappears
            .takeUntilViewWillDisappear(self)
            .map { ($0 as! RACTuple).first as! UIScrollView }
            .logLifeCycle(LogContext.Nearby, signalName: "scrollViewDidEndScrollingAnimation:")
            .map { scrollView -> NSIndexPath? in
                if let
                    collectionView = scrollView as? UICollectionView,
                    lastCell = collectionView.visibleCells().last,
                    indexPath = collectionView.indexPathForCell(lastCell) {
                        return indexPath
                }
                else {
                    return nil
                }
            }
            .ignoreNil()
            .flatMap(.Merge) { [weak self] indexPath -> SignalProducer<MKPointAnnotation, NSError> in
                if let this = self {
                    // After an end scrolling is detected, we must cancel the `performSelector`, otherwise this function will get called multiple times.
                    NSObject.cancelPreviousPerformRequestsWithTarget(this)
                    
                    let business = this.viewmodel.collectionDataSource.array[indexPath.section]
                    
                    /// Center the map to the annotation.
                    return business.annotation.producer
                        .promoteErrors(NSError)
                }
                else {
                    return SignalProducer<MKPointAnnotation, NSError>.empty
                }
            }
            .startWithNext { [weak mapView = self.mapView] annotation in
                
                if let mapView = mapView {
                    // Select the annotation
                    mapView.selectAnnotation(annotation, animated: true)
                    
                    // center the map on the annotation if it is not already in view
                    let visibleAnnotations = mapView.annotationsInMapRect(mapView.visibleMapRect)
                    if !visibleAnnotations.contains(annotation) {
                        mapView.setCenterCoordinate(annotation.coordinate, animated: true)
                    }
                    
                }
            }
        
        // if we reach the last item of the collection view, start the query for pagination
        compositeDisposable += rac_signalForSelector(Selector("scrollViewDidEndDragging:willDecelerate:"), fromProtocol: UIScrollViewDelegate.self).toSignalProducer()
            // Completes the signal when the view controller disappears
            .takeUntilViewWillDisappear(self)
            .logLifeCycle(LogContext.Nearby, signalName: "scrollViewDidEndDragging:willDecelerate:")
            .map { (($0 as! RACTuple).first as! UICollectionView).indexPathsForVisibleItems().first }
            .ignoreNil()
            // if we reach the last item of the collection view, start the query for pagination
            .filter { $0.section == self.businessCollectionView.numberOfSections() - 1 }
            .flatMap(FlattenStrategy.Merge) { _ in
                self.viewmodel.currentLocation
            }
            .flatMap(FlattenStrategy.Merge) { self.viewmodel.getAdditionalBusinesses($0) }
            .start()
        
        /**
        Assigning UITableView delegate has to happen after signals are established.
        
        - tableView.delegate is assigned to self somewhere in UITableViewController designated initializer
        
        - UITableView caches presence of optional delegate methods to avoid -respondsToSelector: calls
        
        - You use -rac_signalForSelector:fromProtocol: and RAC creates method implementation for you in runtime. But UITableView knows nothing about this implementation, it still thinks that there's no such method
        
        The solution is to reassign delegate after all your -rac_signalForSelector:fromProtocol: calls:
        */
        businessCollectionView.delegate = nil
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
    
    - parameter collectionView: An object representing the collection view requesting this information.
    
    - returns: The number of sections in collectionView.
    */
    public func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return viewmodel.collectionDataSource.array.count
    }
    
    /**
    Asks the data source for the number of items in the specified section.
    
    - parameter collectionView: An object representing the collection view requesting this information.
    - parameter section:        An index number identifying a section in collectionView. This index value is 0-based.
    
    - returns: The number of rows in section.
    */
    public func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return NumberOfRowsInCollectionView
    }
    
    /**
    Asks the data source for the cell that corresponds to the specified item in the collection view.
    
    - parameter collectionView: An object representing the collection view requesting this information.
    - parameter indexPath:      The index path that specifies the location of the item.
    
    - returns: A configured cell object. You must not return nil from this method.
    */
    public func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = businessCollectionView.dequeueReusableCellWithReuseIdentifier(CellIdentifier, forIndexPath: indexPath) as! NearbyCollectionViewCell
        let business = viewmodel.collectionDataSource.array[indexPath.section]
        cell.bindToViewModel(business)
        
        return cell
    }
}

extension NearbyViewController : UIScrollViewDelegate {
    
    /**
    Tells the delegate when the user scrolls the content view within the receiver.
    
    - parameter scrollView: The scroll-view object in which the scrolling occurred.
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
    
    - parameter collectionView:       The collection view object displaying the flow layout.
    - parameter collectionViewLayout: The layout object requesting the information.
    - parameter indexPath:            The index path of the item.
    
    - returns: The width and height of the specified item. Both values must be greater than 0.
    */
    public func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return collectionView.bounds.size
    }
}
