//
//  DetailNavigationViewController.swift
//  XListing
//
//  Created by Bruce Li on 2015-06-02.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import UIKit
import MapKit
import ReactiveCocoa

public final class DetailNavigationMapViewController: XUIViewController {

    // MARK: - UI Controls
    @IBOutlet private weak var mapView: MKMapView!
    @IBOutlet private weak var backButton: UIButton!
    @IBOutlet private weak var navigateButton: UIButton!

    // MARK: - Proxies
    private let (_goBackProxy, _goBackSink) = SignalProducer<CompletionHandler?, NoError>.buffer(1)
    public var goBackProxy: SignalProducer<CompletionHandler?, NoError> {
        return _goBackProxy
    }
    
    // MARK: Properties
    
    private var viewmodel: DetailNavigationMapViewModel!
    private let compositeDisposable = CompositeDisposable()

    // MARK: Setups
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        
        setupBackButton()
        setupNavigateButton()
    }
    
    public override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }

    public override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func setupBackButton() {
        let goBack = Action<UIButton, Void, NoError> { button in
            return SignalProducer { sink ,disposable in
                sendNext(self._goBackSink, nil)
                
                sendCompleted(sink)
            }
        }
        
        backButton.addTarget(goBack.unsafeCocoaAction, action: CocoaAction.selector, forControlEvents: UIControlEvents.TouchUpInside)
        
    }
    
    private func setupNavigateButton() {
        
        let openMaps = Action<UIButton, Void, NoError> { [weak self] button in
            return SignalProducer { sink, disposable in
                if let this = self {
                    disposable += combineLatest(
                            this.viewmodel.annotation.producer,
                            this.viewmodel.region.producer |> ignoreNil
                        )
                        |> start(next: { annotation, region in
                            let placemark = MKPlacemark(coordinate: region.center, addressDictionary: nil)
                            let mapItem = MKMapItem(placemark: placemark)
                            mapItem.name = annotation.title
            
                            MKMapItem.openMapsWithItems([MKMapItem.mapItemForCurrentLocation(), mapItem], launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
                            
                            sendCompleted(sink)
                        })
                }
                

            }
        }
        
        navigateButton.addTarget(openMaps.unsafeCocoaAction, action: CocoaAction.selector, forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    
    deinit {
        compositeDisposable.dispose()
    }
    
    // MARK: Bindings
    
    public func bindToViewModel(viewmodel: DetailNavigationMapViewModel) {
        self.viewmodel = viewmodel
        
        compositeDisposable += self.viewmodel.annotation.producer
            |> takeUntil(
                rac_signalForSelector(Selector("viewDidDisappear:")).toSignalProducer()
                    |> toNihil
            )
            |> start(next: { [weak self] annotation in
                self?.mapView.addAnnotation(annotation)
            })
        
        compositeDisposable += self.viewmodel.region.producer
            |> takeUntil(
                rac_signalForSelector(Selector("viewDidDisappear:")).toSignalProducer()
                    |> toNihil
            )
            |> ignoreNil
            |> start(next: { [weak self] region in
                self?.mapView.setRegion(region, animated: false)
            })
    }
}

extension DetailNavigationMapViewController : MKMapViewDelegate {
    
    // Display the custom map pin
    public func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        if (annotation is MKUserLocation) {
            //if annotation is not an MKPointAnnotation (eg. MKUserLocation),
            //return nil so map draws default view for it (eg. blue dot)...
            return nil
        }
        
        let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: nil)
        annotationView.image = UIImage(named: ImageAssets.mapPin)
        annotationView.canShowCallout = true
        annotationView.annotation = annotation
        
        return annotationView
    }
}