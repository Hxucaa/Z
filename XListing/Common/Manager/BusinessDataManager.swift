//
//  FeaturedBusinessDataManager.swift
//  XListing
//
//  Created by Lance Zhu on 2015-04-02.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import SwiftTask

public class BusinessDataManager {
    /**
        This function saves the BusinessEntity and returns true if success otherwise false.
        
        :params: object A BusinessEntity.
        :returns: a generic Task containing a boolean value.
    */
    public func save(business: BusinessEntity) -> Task<Int, Bool, NSError> {
        
        // save business to the cloud
        func saveTask (bus: BusinessEntity) -> Task<Int, Bool, NSError> {
            let task = Task<Int, Bool, NSError> { progress, fulfill, reject, configure in
                bus.saveInBackgroundWithBlock { (success: Bool, error: NSError!) -> Void in
                    if success {
                        fulfill(success)
                    }
                    else {
                        reject(error)
                    }
                }
            }
            
            return task
        }
        
        // get complete address
        let addressString: String? = business.completeAddress
        if let address = addressString {
            
            // get geolocation from the address
            let forwardGeocodingTask = forwardGeocoding(address)
            
            let resultTask = forwardGeocodingTask
                .success { geopoint -> Task<Int, Bool, NSError> in
                    business.geopoint = geopoint
                    
                    return saveTask(business)
                    
                }
                .failure { (error: NSError?, isCancelled: Bool) -> Bool in
                    if let error = error {
                        println("Forward geocoding failed with error: \(error.localizedDescription)")
                    }
                    if isCancelled {
                        println("Forward geocoding cancelled")
                    }
                    return false
                }
            return resultTask
        }
        else {
            return saveTask(business)
        }
    }
    
    
    /**
        This function finds the BusinessEntity based on the query.

        :params: query A PFQuery.
        :returns: a Task containing the result Entity in optional.
    */
    public func getFirst(var _ query: PFQuery = BusinessEntity.query()) -> Task<Int, BusinessEntity?, NSError> {
        let task = Task<Int, PFObject, NSError> { progress, fulfill, reject, configure in
            self.enhanceQuery(&query)
            query.getFirstObjectInBackgroundWithBlock { (object, error) -> Void in
                if error == nil {
                    fulfill(object)
                }
                else {
                    reject(error)
                }
            }
        }
        .success { object -> BusinessEntity? in
            return object as? BusinessEntity
        }

        return task
    }
    
    /**
        Finds the BusinessEntities based on the query.
        
        :params: query A PFQuery.
        :returns: A Task which contains an array of BusinessEntity.
    */
    public func findBy(var _ query: PFQuery = BusinessEntity.query()) -> Task<Int, [BusinessEntity], NSError> {
        
        let task = Task<Int, [AnyObject], NSError> { progress, fulfill, reject, configure in
            self.enhanceQuery(&query)
            query.findObjectsInBackgroundWithBlock { (objects: [AnyObject]!, error: NSError!) -> Void in
                if error == nil {
                    fulfill(objects)
                }
                else {
                    reject(error)
                }
            }
        }
        .success { (objects: [AnyObject]) -> [BusinessEntity] in
            let businesses = objects as [BusinessEntity]
            
            return businesses
        }
        
        return task
    }
    
    private func enhanceQuery(inout query: PFQuery) {
        
    }
    
    
}

// geolocation service
extension BusinessDataManager {
    /**
    This function translate physical address to geolocation coordinates.
    
    :params: address A String of the address.
    :returns: a Task containing a GeoPointEntity which contains the location data.
    */
    private func forwardGeocoding(address: String) -> Task<Int, GeoPointEntity, NSError> {
        let task = Task<Int, [AnyObject], NSError> { progress, fulfill, reject, configure in
            CLGeocoder().geocodeAddressString(address, completionHandler: { (placemarks: [AnyObject]!, error: NSError!) -> Void in
                if error == nil && placemarks.count > 0 {
                    fulfill(placemarks)
                }
                else {
                    reject(error)
                }
            })
            }
            .success { (placemarks: [AnyObject]) -> GeoPointEntity in
                // convert to GeoPointEntity
                let placemark = placemarks[0] as CLPlacemark
                let location = placemark.location
                let geopoint = GeoPointEntity(location)
                
                return geopoint
        }
        return task
    }
}