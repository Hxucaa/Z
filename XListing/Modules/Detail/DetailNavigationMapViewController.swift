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
    private lazy var mapView: MKMapView = {
        let mapView = MKMapView()
        return mapView
        }()

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
        view.addSubview(mapView)
        constrain(mapView) { view in
            view.leading == view.superview!.leading
            view.top == view.superview!.topMargin
            view.bottom == view.superview!.bottomMargin
            view.trailing == view.superview!.trailing
        }
        setupNavBar()
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
    
    public func setupNavBar() {
        var gradientNavView: UIView = UIView(frame: CGRectMake(0.0, 0.0, UIScreen.mainScreen().bounds.size.width, 84.0))
        let colorTop = UIColor(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 0.7).CGColor
        let colorBottom = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 0.0).CGColor
        var gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = gradientNavView.bounds
        gradient.colors = [colorTop, colorBottom]
        gradient.locations = [0.0, 1.0]
        gradientNavView.layer.insertSublayer(gradient, atIndex: 0)
        view.addSubview(gradientNavView)
    }
    
    private func setupBackButton() {
        var backButton = UIButton(frame: CGRectMake(5, 20, 62, 37))
        let attributes = [NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName: UIFont(name: "FontAwesome", size: 17)!]
        
        var attributedString = NSAttributedString(string: Icons.Chevron+" 返回", attributes: attributes)
        backButton.setAttributedTitle(attributedString, forState: UIControlState.Normal)
        
        let goBack = Action<UIButton, Void, NoError> { button in
            return SignalProducer { sink ,disposable in
                sendNext(self._goBackSink, nil)
                
                sendCompleted(sink)
            }
        }
        
        backButton.addTarget(goBack.unsafeCocoaAction, action: CocoaAction.selector, forControlEvents: UIControlEvents.TouchUpInside)
        
        view.addSubview(backButton)
        
    }
    
    private func setupNavigateButton() {
        
        var deviceWidth = UIScreen.mainScreen().bounds.size.width
        
        var deviceHeight = UIScreen.mainScreen().bounds.size.height
        
        var navigateButton = UIButton(frame: CGRectMake(deviceWidth-67, 20, 62, 37))
        
        let attributes = [NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName: UIFont.boldSystemFontOfSize(17)]
        
        var attributedString = NSAttributedString(string: "导航", attributes: attributes)
        
        navigateButton.setAttributedTitle(attributedString, forState: UIControlState.Normal)
        
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
        
        view.addSubview(navigateButton)
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