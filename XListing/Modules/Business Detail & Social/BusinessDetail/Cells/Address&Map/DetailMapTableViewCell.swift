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
import Cartography

private let MapHeight = CGFloat(200)

public final class DetailMapTableViewCell: UITableViewCell {
    
    // MARK: - UI Controls
    private lazy var mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.scrollEnabled = false
        mapView.zoomEnabled = false
        mapView.rotateEnabled = false
        mapView.userInteractionEnabled = false
        
        mapView.delegate = self
        
        return mapView
    }()
    
    // MARK: - Proxies
    
    // MARK: - Properties
    private var viewmodel: DetailAddressAndMapViewModel!
    private let compositeDisposable = CompositeDisposable()
    
    // MARK: - Setups
    
    deinit {
        compositeDisposable.dispose()
    }
    
    public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        layoutMargins = UIEdgeInsetsZero
        separatorInset = UIEdgeInsetsZero
        contentView.layoutMargins = UIEdgeInsetsZero
        
        selectionStyle = UITableViewCellSelectionStyle.None
        
        contentView.addSubview(mapView)
        
        constrain(mapView) { view in
            view.leading == view.superview!.leadingMargin
            view.top == view.superview!.topMargin
            view.bottom == view.superview!.bottomMargin
            view.trailing == view.superview!.trailingMargin
            view.height == MapHeight
        }
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Bindings
    public func bindToViewModel(viewmodel: DetailAddressAndMapViewModel) {
        self.viewmodel = viewmodel
        
        compositeDisposable += self.viewmodel.annotation.producer
            .takeUntilPrepareForReuse(self)
            .startWithNext { [weak self] annotation in
                self?.mapView.addAnnotation(annotation)
            }
        
        compositeDisposable += self.viewmodel.cellMapRegion.producer
            .takeUntilPrepareForReuse(self)
            .startWithNext { [weak self] region in
                self?.mapView.setRegion(region, animated: false)
            }
    }
}

extension DetailMapTableViewCell : MKMapViewDelegate {
    public func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
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
