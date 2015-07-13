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

private let DetailNavigationMapViewControllerXib = "DetailNavigationMapViewController"

public final class DetailMapTableViewCell: UITableViewCell {

    // MARK: - UI
    // MARK: Controls
    @IBOutlet weak var mapView: MKMapView!
    
    // MARK: Delegate
    public weak var delegate: AddressAndMapDelegate!
    
    private var viewmodel: DetailAddressAndMapViewModel!
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        mapView.delegate = self
        
        // Action
        let pushNavMap = Action<UITapGestureRecognizer, Void, NoError> { [unowned self] gesture in
            return SignalProducer { [unowned self] sink, disposable in
                
                let navVC = DetailNavigationMapViewController(nibName: DetailNavigationMapViewControllerXib, bundle: nil)
                navVC.bindToViewModel(self.viewmodel.detailNavigationMapViewModel)
                self.delegate.pushNavigationMapViewController(navVC)
                sendCompleted(sink)
            }
        }
        
        let tapGesture = UITapGestureRecognizer(target: pushNavMap.unsafeCocoaAction, action: CocoaAction.selector)
        mapView.addGestureRecognizer(tapGesture)
    }

    public override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public func bindToViewModel(viewmodel: DetailAddressAndMapViewModel) {
        self.viewmodel = viewmodel
        
        viewmodel.annotation.producer
            |> start(next: { [unowned self] annotation in
                self.mapView.addAnnotation(annotation)
            })
        
        viewmodel.cellMapRegion.producer
            |> start(next: { [unowned self] region in
                self.mapView.setRegion(region, animated: false)
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
        
        let reuseId = "test"
        var anView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId)
        if anView == nil {
            anView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            anView.image = UIImage(named:"mapPin")
            anView.canShowCallout = true
        }
        else {
            //we are re-using a view, update its annotation reference...
            anView.annotation = annotation
        }
        return anView
    }
}
