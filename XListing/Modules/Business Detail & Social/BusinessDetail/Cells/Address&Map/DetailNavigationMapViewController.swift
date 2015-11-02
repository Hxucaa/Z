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
import Cartography

public final class DetailNavigationMapViewController: XUIViewController {

    // MARK: - UI Controls
    private lazy var navBarView: UIView = {
        
        let view = UIView(frame: CGRectMake(0.0, 0.0, UIScreen.mainScreen().bounds.size.width, 84.0))
        let colorTop = UIColor(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 0.7).CGColor
        let colorBottom = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 0.0).CGColor
        var gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = view.bounds
        gradient.colors = [colorTop, colorBottom]
        gradient.locations = [0.0, 1.0]
        view.layer.insertSublayer(gradient, atIndex: 0)
        
        return view
    }()
    
    private lazy var backButton: UIButton = {
        let button = UIButton()
        let attributes = [NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName: UIFont(name: "FontAwesome", size: 17)!]
        
        var attributedString = NSAttributedString(string: Icons.Chevron + " 返回", attributes: attributes)
        button.setAttributedTitle(attributedString, forState: UIControlState.Normal)
        
        let goBack = Action<UIButton, Void, NoError> { button in
            return SignalProducer { sink ,disposable in
                sendNext(self._goBackSink, nil)
                
                sendCompleted(sink)
            }
        }
        
        button.addTarget(goBack.unsafeCocoaAction, action: CocoaAction.selector, forControlEvents: UIControlEvents.TouchUpInside)
        
        return button
    }()
    
    private lazy var navigateButton: UIButton = {
        let button = UIButton()
        let attributes = [NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName: UIFont.boldSystemFontOfSize(17)]
        let attributedString = NSAttributedString(string: "导航", attributes: attributes)
        button.setAttributedTitle(attributedString, forState: UIControlState.Normal)
        
        let openMaps = Action<UIButton, Void, NoError> { [weak self] button in
            return SignalProducer { sink, disposable in
                if let this = self {
                    disposable += combineLatest(
                        this.viewmodel.annotation.producer |> ignoreNil,
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
        
        button.addTarget(openMaps.unsafeCocoaAction, action: CocoaAction.selector, forControlEvents: UIControlEvents.TouchUpInside)
        
        return button
    }()
    
    private lazy var mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.delegate = self
        return mapView
    }()

    // MARK: - Proxies
    private let (_goBackProxy, _goBackSink) = SignalProducer<CompletionHandler?, NoError>.buffer(1)
    public var goBackProxy: SignalProducer<CompletionHandler?, NoError> {
        return _goBackProxy
    }
    
    // MARK: - Properties
    
    private var viewmodel: DetailNavigationMapViewModel!
    private let compositeDisposable = CompositeDisposable()

    // MARK: - Setups
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(mapView)
        navBarView.addSubview(backButton)
        navBarView.addSubview(navigateButton)
        view.addSubview(navBarView)
        
        constrain(mapView) { view in
            view.leading == view.superview!.leading
            view.top == view.superview!.topMargin
            view.bottom == view.superview!.bottomMargin
            view.trailing == view.superview!.trailing
        }
        
        constrain(navBarView) { view in
            view.leading == view.superview!.leading
            view.top == view.superview!.top
            view.trailing == view.superview!.trailing
            view.height == 84
        }
        
        constrain(backButton, navigateButton) { backButton, navigateButton in
            align(centerY: backButton, navigateButton)
            
            backButton.centerY == backButton.superview!.centerY
            backButton.leading == backButton.superview!.leadingMargin
            backButton.height == backButton.superview!.height * 0.74
            
            navigateButton.trailing == navigateButton.superview!.trailingMargin
            navigateButton.height == backButton.height
        }
    }
    
    deinit {
        compositeDisposable.dispose()
    }
    
    // MARK: - Bindings
    
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
    public func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView! {
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