//
//  DetailBusinessMapViewController.swift
//  XListing
//
//  Created by Bruce Li on 2015-06-02.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import UIKit
import MapKit

public final class DetailBusinessMapViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    internal var region : MKCoordinateRegion!
    internal var businessAnnotation: MKPointAnnotation!
    internal var businessLocation: CLLocation!

    public override func viewDidLoad() {
        super.viewDidLoad()
        mapView.setRegion(region, animated: false)
        mapView.addAnnotation(businessAnnotation)
        mapView.delegate = self

        var openInMapsButton = UIBarButtonItem(title: "导航", style: UIBarButtonItemStyle.Plain, target: self, action: "openInMapsApp")
        self.navigationItem.rightBarButtonItem = openInMapsButton
    }

    public override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    public func openInMapsApp() {
        var placemark = MKPlacemark(coordinate: region.center, addressDictionary: nil)
        var mapItem = MKMapItem(placemark: placemark)
        mapItem.name = businessAnnotation.title
        
        MKMapItem.openMapsWithItems([MKMapItem.mapItemForCurrentLocation(), mapItem], launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
    }
    
    // Display the custom map pin
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
