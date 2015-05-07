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

private let NearbyTableViewCellXIB = "NearbyTableViewCellXIB"
private let CellIdentifier = "NearbyCell"

public class NearbyViewController: UIViewController , UITableViewDelegate, UITableViewDataSource{
    
    private var mapView = MKMapView()
    private var dataSources: NSMutableArray? = []
    private var contentView: HorizontalScrollContentView!
    private var locationData: NSMutableArray? = []
    private var pageNumber: Int = 0
    
    //private var tView = UITableView()
    private var tableArray: NSMutableArray? = []
    
    private var nearbyBusinessDataArray: NSMutableArray? = []
    
    /// View Model
    public var nearbyVM: INearbyViewModel?
    
    public weak var navigationDelegate: NearbyNavigationDelegate?
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
       
         initMapView()
    
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
                self.nearbyBusinessDataArray?.addObject(businessVM)
                self.contentView.addSubview(self.newTableView())
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
                //startMapViewAtALocation(location)
                startMapViewAtALocation(CLLocation(latitude: 49.27623, longitude: -123.12941))
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
        
        nearbyVM!.getBusiness()
        setupMapViewSignal()

    }
    
    private func newTableView() -> UITableView {
       
        var tableView = NearbyTableView()
        
        //register the xib file for the custom cell
        var nib = UINib(nibName: NearbyTableViewCellXIB, bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: CellIdentifier)

        tableView.frame = CGRectZero
        
        tableView.backgroundColor = UIColor.clearColor()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.showsHorizontalScrollIndicator = false
        tableView.showsVerticalScrollIndicator = false
        tableView.decelerationRate = UIScrollViewDecelerationRateFast
        tableView.rowHeight = 80
        tableView.scrollEnabled = false
        
        tableArray?.addObject(tableView)
        
        return tableView
    }
    
    public func shiftMapCenter(biz: BusinessViewModel){
     var bizCoordinate = CLLocationCoordinate2D(latitude: biz.latitude!, longitude: biz.longitude!)
        let span = MKCoordinateSpanMake(0.07, 0.07)
        let region = MKCoordinateRegion(center: bizCoordinate, span: span)
        self.mapView.setRegion(region, animated: true)

    }
    
    
    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var tView:UITableView = tableArray?.objectAtIndex(self.pageNumber) as! UITableView
        
        var biz:BusinessViewModel = self.nearbyBusinessDataArray?.objectAtIndex(self.pageNumber) as! BusinessViewModel
        
        var cell:NearbyTableViewCell = tView.dequeueReusableCellWithIdentifier(CellIdentifier) as! NearbyTableViewCell
        
        cell.bizName.text = biz.nameSChinese
        cell.bizDetail.text = "130+ 人想去 ｜ 开车25分钟"
        cell.bizHours.text = "今天 10:00AM - 10:00PM"
        cell.bizImage!.hnk_setImageFromURL(NSURL(string: biz.coverImageUrl!)!, failure: {
            println("Image loading failed: \($0)")
        })
        return cell
        
    }
    
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var biz:BusinessViewModel = self.nearbyBusinessDataArray?.objectAtIndex(self.pageNumber) as! BusinessViewModel
        
        //TO DO:
        //PUSH TO DETAIL VIEW
        navigationDelegate?.pushDetail(biz);
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
            
        self.pageNumber = Int(pageNumber)
        var tView:UITableView = tableArray?.objectAtIndex(self.pageNumber) as! UITableView
        tView.reloadData()
        var biz:BusinessViewModel = self.nearbyBusinessDataArray?.objectAtIndex(self.pageNumber) as! BusinessViewModel
        shiftMapCenter(biz)
        
        targetContentOffset.memory.x = pageNumber * pageWidth!
        
    }
    
}