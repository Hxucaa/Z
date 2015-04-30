//
//  NearbyBusinessViewController.swift
//  XListing
//
//  Created by Bruce Li on 2015-04-05.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import UIKit
import MapKit
import ReactKit
import SwiftTask

public class NearbyViewController: UIViewController {
    
    private var mapView = MKMapView()
    private var dataSources: NSMutableArray? = []
    private var contentView: HorizontalScrollContentView!
    private var locationData: NSMutableArray? = []
    
    private var nearbyBusinessDataArray: Array<BusinessViewModel>? = []
    
    /// View Model
    public var nearbyVM: INearbyViewModel?
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        nearbyVM!.getBusiness()
        initMapView()
        
        // Do any additional setup after loading the view.
        
        setupMapViewSignal()
        
        
        
    }
    
    public override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func setupMapViewSignal() {
        let businessVMArrSignal = nearbyVM!.businessVMArr.signal().ownedBy(self)
        businessVMArrSignal ~> { [unowned self] changedValues, change, indexSet in
            if change == .Insertion {
                let businessVM = changedValues![0] as! BusinessViewModel
                let annotation = MKPointAnnotation()
                annotation.coordinate = CLLocationCoordinate2D(latitude: businessVM.latitude!, longitude: businessVM.longitude!)
                annotation.title = businessVM.nameSChinese
                annotation.subtitle = businessVM.nameEnglish
                self.mapView.addAnnotation(annotation)
            }
        }
    }
    
    private func initMapView() -> Task<Int, Void, NSError> {
        // start a map view focused at a certain location
        let startMapViewAtALocation = { (location: CLLocation) -> Void in
            self.mapView.frame = self.view.bounds
            
            self.mapView.autoresizingMask = UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleHeight
            
            let span = MKCoordinateSpanMake(0.07, 0.07)
            let region = MKCoordinateRegion(center: location.coordinate, span: span)
            self.mapView.setRegion(region, animated: true)
            
            self.view.addSubview(self.mapView)
            self.initScrollView()
            
        }
        
        let task = nearbyVM!.getCurrentLocation()
            .success { [unowned self] location -> Void in
                // with current location
                startMapViewAtALocation(location)
            }
            .failure { [unowned self] (error, isCancelled) -> Void in
                // with hardcoded location
                //TODO: better support for hardcoded location
                println("Location service failed! Using default Vancouver location.")
                startMapViewAtALocation(CLLocation(latitude: 49.27623, longitude: -123.12941))
            }
        
        return task
    }
    
    private func initScrollView (){
        var scrollView = HorizontalScrollView()
        scrollView.frame = self.view.bounds
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.decelerationRate = UIScrollViewDecelerationRateFast
        scrollView.autoresizingMask = UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleHeight
        self.view.addSubview(scrollView)
        
        self.contentView = HorizontalScrollContentView()
        
        scrollView.addSubview(self.contentView)
        scrollView.delegate = self
        
        
        println(self.contentView.subviews.count)
        self.contentView.addSubview(newTableView())
        self.contentView.addSubview(newTableView())
        self.contentView.addSubview(newTableView())
        self.contentView.addSubview(newTableView())
        println(self.contentView.subviews.count)
    }
    
    private func newTableView() -> NearbyTableView {
        var dataSource =  NearbyTableDataSource()
        //dataSource.numberOfRows = numberOfRows
        dataSource.dataArray = nearbyBusinessDataArray
        
        dataSources?.addObject(dataSource)
        
        var tableView = NearbyTableView()
        tableView.frame = CGRectZero
        
        tableView.backgroundColor = UIColor.clearColor()
        tableView.dataSource = dataSource
        tableView.delegate = dataSource
        tableView.showsHorizontalScrollIndicator = false
        tableView.showsVerticalScrollIndicator = false
        tableView.decelerationRate = UIScrollViewDecelerationRateFast
        tableView.rowHeight = 44
        
        return tableView
    }
}

extension NearbyViewController : UIScrollViewDelegate {
    
    public func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        var pageWidth = contentView.pageWidth
        
        var pageNumber = targetContentOffset.memory.x/pageWidth!
        if velocity.x < 0 {
            pageNumber = floor(pageNumber)
        }
        else {
            pageNumber = ceil(pageNumber)
        }
        
        var count = contentView.subviews.count
        
        
        targetContentOffset.memory.x = pageNumber * pageWidth!
        
    }
}