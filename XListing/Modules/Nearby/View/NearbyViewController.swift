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
import SDWebImage

private let NearbyTableViewCellXIB = "NearbyTableViewCell"
private let CellIdentifier = "NearbyCell"

public final class NearbyViewController: XUIViewController , UITableViewDelegate, UITableViewDataSource{
    
    private let mapView = MKMapView()
    private let horizontalScrollContentView = HorizontalScrollContentView()
    private var pageNumber: Int = 0
    
    private var tableArray = [NearbyTableView]()
    
    @IBOutlet weak var profileButton: UIBarButtonItem!
    
    /// View Model
    private var nearbyVM: INearbyViewModel!
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
        setupProfileButton()
        
        initMapView()
        initScrollView()
    
        // Process the signal to do something else. That's why you need to have a reference to the signal.
        let locationStream = nearbyVM.getCurrentLocation()
        locationStream.ownedBy(self)
        locationStream ~> { [unowned self] location -> Void in
            self.setInitialCenter(location)
        }

        setupMapViewSignal()
        
        // Don't care about the result. Therefore don't need to hold a reference to the signal.
        nearbyVM.getBusiness()
    }
    
    public override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    public func bindToViewModel(viewmodel: INearbyViewModel) {
        nearbyVM = viewmodel
    }
    
    /**
    React to Profile Button and present ProfileViewController.
    */
    private func setupProfileButton() {
        let profileButtonSignal = profileButton.stream().ownedBy(self)
        profileButtonSignal ~> { [unowned self] button -> Void in
            nearbyVM?.pushProfileModule()
        }
        
    }
    
    /**
    Initialize map view.
    
    */
    private func initMapView() {
        // start a map view focused at a certain location
        mapView.frame = view.bounds
        
        mapView.autoresizingMask = UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleHeight
        
        view.addSubview(mapView)
    }
    
    /**
    Intialize scroll view.
    
    */
    private func initScrollView (){
        let scrollView = HorizontalScrollView()
        scrollView.frame = view.bounds
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.decelerationRate = UIScrollViewDecelerationRateFast
        scrollView.autoresizingMask = UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleHeight
        
        scrollView.addSubview(horizontalScrollContentView)
        scrollView.delegate = self
        
        view.addSubview(scrollView)
    }
    
    private func setupMapViewSignal() {

        let businessVMArrSignal = nearbyVM.businessDynamicArr.stream().ownedBy(self)
        businessVMArrSignal ~> { [unowned self] changedValues, change, indexSet in
            if change == .Insertion {
                let businessVM = changedValues![0] as! NearbyHorizontalScrollCellViewModel
                
                // Setup annotation
                let annotation = MKPointAnnotation()
                annotation.coordinate = businessVM.cllocation.coordinate
                annotation.title = businessVM.businessName
//                annotation.subtitle = businessVM.nameEnglish
                
                // Add annotation to map
                self.mapView.addAnnotation(annotation)
                
                self.horizontalScrollContentView.addSubview(self.newTableView())
            }
        }
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
        
        tableArray.append(tableView)
        
        return tableView
    }
    
    /**
    Move the map view to center on a location.
    
    :param: location The geolocation.
    */
    private func setInitialCenter(location: CLLocation){
        let span = MKCoordinateSpanMake(0.07, 0.07)
        let region = MKCoordinateRegion(center: location.coordinate, span: span)
        mapView.setRegion(region, animated: false)
    }
    
    
    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var tView = tableArray[pageNumber]
        
        var biz = nearbyVM.businessDynamicArr.proxy[pageNumber] as! NearbyHorizontalScrollCellViewModel
        
        var cell = tView.dequeueReusableCellWithIdentifier(CellIdentifier) as! NearbyTableViewCell
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        cell.bizName.text = biz.businessName
        cell.bizDetail.text = "130+ 人想去 ｜ 开车25分钟"
        cell.bizHours.text = "今天 10:00AM - 10:00PM"
        if let url = biz.coverImageNSURL {
            cell.bizImage?.sd_setImageWithURL(url)
        }
        
        return cell
        
    }
    
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        nearbyVM.pushDetailModule(indexPath.section)
    }
    
    
}

extension NearbyViewController : UIScrollViewDelegate {
    
    public func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        var pageWidth = horizontalScrollContentView.pageWidth
        
        var pageNumber = targetContentOffset.memory.x/pageWidth!
        if velocity.x < 0 {
            pageNumber = floor(pageNumber)
        }
        else {
            pageNumber = ceil(pageNumber)
        }
        
        var count = horizontalScrollContentView.subviews.count
            
        self.pageNumber = Int(pageNumber)
        var tView = tableArray[self.pageNumber]
        tView.reloadData()
        var biz = nearbyVM.businessDynamicArr.proxy[self.pageNumber] as! NearbyHorizontalScrollCellViewModel
        setInitialCenter(biz.cllocation)
        
        targetContentOffset.memory.x = pageNumber * pageWidth!
        
    }
    
}