//
//  DetailMapTableViewCell.swift
//  XListing
//
//  Created by Lance Zhu on 2015-06-01.
//  Copyright (c) 2016 Lance Zhu. All rights reserved.
//

import UIKit
import MapKit
import Cartography

private let MapHeight = CGFloat(200)

final class DetailMapTableViewCell: UITableViewCell {
    
    // MARK: - UI Controls
    private lazy var mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.scrollEnabled = false
        mapView.zoomEnabled = false
        mapView.rotateEnabled = false
        mapView.userInteractionEnabled = false
        
        return mapView
    }()
    
    // MARK: - Properties
    
    // MARK: - Initializers
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
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

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Bindings
    func bindToData(annotation: MKPointAnnotation, cellMapRegion: MKCoordinateRegion, mapViewDelegate: MKMapViewDelegate) {
        mapView.addAnnotation(annotation)
        mapView.setRegion(cellMapRegion, animated: false)
        
        mapView.delegate = mapViewDelegate
    }
}
