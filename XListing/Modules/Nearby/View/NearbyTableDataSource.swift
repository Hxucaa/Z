//
//  NearbyTableDataSource.swift
//  XListing
//
//  Created by Bruce Li on 2015-04-05.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import UIKit

class NearbyTableDataSource: NSObject, UITableViewDataSource, UITableViewDelegate {
    
    //var numberOfRows:Int?
    internal var dataArray: Array<BusinessViewModel>? = []
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray!.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        tableView.registerClass(UITableViewCell.classForCoder(), forCellReuseIdentifier: "Cell")
        
        var cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as? UITableViewCell
        
        if cell == nil{
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "Cell")
        }
        
        let row = indexPath.row
        
        if (dataArray?.count > row){
            let business = dataArray?[row]
            
            
            cell!.textLabel!.text = business?.nameEnglish
            cell!.textLabel!.font = UIFont.systemFontOfSize(13);
            //cell!.detailTextLabel!.text = business?.distance
            cell!.imageView!.image = UIImage(named: "sampleBuns")
        }
        return cell!
    }
    
    
    func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        var yMin = -scrollView.contentInset.top
        var yMax = min(0, scrollView.contentSize.height - scrollView.bounds.size.height)
        
        if targetContentOffset.memory.y < yMax {
            if velocity.y < 0 {
                targetContentOffset.memory.y = yMin
            }else{
                targetContentOffset.memory.y = yMax
            }
        }
        
    }
}