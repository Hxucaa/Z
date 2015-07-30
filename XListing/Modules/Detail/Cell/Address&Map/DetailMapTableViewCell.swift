//
//  DetailMapTableViewCell.swift
//  XListing
//
//  Created by Bruce Li on 2015-06-01.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import UIKit
import ReactiveCocoa
import MapKit

public final class DetailMapTableViewCell: UITableViewCell {

    // MARK: - UI
    // MARK: Controls
    @IBOutlet weak var mapView: MKMapView!
    
    // MARK: - Proxies
    private let (_navigationMapProxy, _navigationMapSink) = SimpleProxy.proxy()
    public var navigationMapProxy: SimpleProxy {
        return _navigationMapProxy
    }
    
    // MARK: - Properties
    private var viewmodel: DetailAddressAndMapViewModel!
    private let compositeDisposable = CompositeDisposable()
    
    // MARK: - Setups
    public override func awakeFromNib() {
        super.awakeFromNib()
        
        layoutMargins = UIEdgeInsetsZero
        preservesSuperviewLayoutMargins = false
        
        setupMapView()
    }

    public override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func setupMapView() {
        
        mapView.delegate = self
        
        // Action
        let pushNavMap = Action<UITapGestureRecognizer, Void, NoError> { [weak self] gesture in
            return SignalProducer { sink, disposable in
                if let this = self {
                    
                    sendNext(this._navigationMapSink, ())
                    
                    sendCompleted(sink)
                }
            }
        }
        
        let tapGesture = UITapGestureRecognizer(target: pushNavMap.unsafeCocoaAction, action: CocoaAction.selector)
        mapView.addGestureRecognizer(tapGesture)
    }
    
    deinit {
        compositeDisposable.dispose()
    }
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        
        compositeDisposable.dispose()
    }
    
    // MARK: Bindings
    public func bindToViewModel(viewmodel: DetailAddressAndMapViewModel) {
        self.viewmodel = viewmodel
        
        compositeDisposable += self.viewmodel.annotation.producer
            |> takeUntilPrepareForReuse(self)
            |> start(next: { [weak self] annotation in
                self?.mapView.addAnnotation(annotation)
            })
        
        compositeDisposable += self.viewmodel.cellMapRegion.producer
            |> takeUntilPrepareForReuse(self)
            |> start(next: { [weak self] region in
                self?.mapView.setRegion(region, animated: false)
            })
    }
}

extension DetailMapTableViewCell : MKMapViewDelegate {
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
