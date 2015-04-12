//
//  NearbyBusinessViewController.swift
//  XListing
//
//  Created by Bruce Li on 2015-04-05.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import UIKit
import MapKit

public class NearbyViewController: UIViewController {
    
    var dataSources: NSMutableArray? = []
    var contentView: HorizontalScrollContentView!
    var locationData: NSMutableArray? = []
    
    internal var nearbyBusinessDataArray: Array<BusinessViewModel>? = []
    
    /// View Model
    public var nearbyVM: INearbyViewModel?
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        initMapView()
        initScrollView()
        // Do any additional setup after loading the view.
    }
    
    public override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initMapView (){
        var mapView = MKMapView()
        mapView.frame = self.view.bounds
        
        mapView.autoresizingMask = UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleHeight
        
        // 1
        var center = CLLocationCoordinate2D(
            latitude: 49.1667,
            longitude: -123.1333
        )
        // 2
        let span = MKCoordinateSpanMake(0.1, 0.1)
        let region = MKCoordinateRegion(center: center, span: span)
        mapView.setRegion(region, animated: true)
        
        
        var location1 = CLLocationCoordinate2D(
            latitude: 49.173805,
            longitude: -123.1317793
        )
        
        //3
        var annotation1 = MKPointAnnotation()
        annotation1.coordinate = location1
        annotation1.title = "Chang'An"
        annotation1.subtitle = "品味长安"
        
        var location2 = CLLocationCoordinate2D(
            latitude: 49.16991,
            longitude: -123.138535
        )
        
        //3
        var annotation2 = MKPointAnnotation()
        annotation1.coordinate = location2
        annotation2.title = "Kirin Restaurant"
        annotation2.subtitle = "麒麟"
        mapView.addAnnotations([annotation1, annotation2])
        
        self.view.addSubview(mapView)
        
    }
    
    func initScrollView (){
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
    
    func newTableView() -> NearbyTableView {
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
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
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