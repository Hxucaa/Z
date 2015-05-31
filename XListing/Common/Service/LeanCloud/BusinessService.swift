//
//  BusinessService.swift
//  XListing
//
//  Created by Lance Zhu on 2015-04-02.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import SwiftTask
import MapKit

public final class BusinessService : ObjectService, IBusinessService {
    
    /**
        This function saves the BusinessDAO and returns true if success otherwise false.
        
        :params: object A BusinessDAO.
        :returns: a generic Task containing a boolean value.
    */
    public func save(business: Business) -> Task<Int, Bool, NSError> {
        
        // get complete address
        let addressString: String? = business.completeAddress
        if let address = addressString {
            
            // get geolocation from the address
            let forwardGeocodingTask = forwardGeocoding(address)
            
            let resultTask = forwardGeocodingTask
                .success { geopoint -> Task<Int, Bool, NSError> in
                    business.geopoint = geopoint
                    
                    return super.save(business)
                    
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
            return super.save(business)
        }
    }
    
    
    /**
        This function finds the BusinessDAO based on the query.

        :params: query A PFQuery.
        :returns: a Task containing the result DAO in optional.
    */
    public func getFirst(var query: PFQuery?) -> Task<Int, Business?, NSError> {
        if query == nil {
            query = Business.query()
        }
        
        let task = Task<Int, PFObject, NSError> { progress, fulfill, reject, configure in
            self.enhanceQuery(&query!)
            query!.getFirstObjectInBackgroundWithBlock { (object, error) -> Void in
                if error == nil {
                    fulfill(object!)
                }
                else {
                    reject(error!)
                }
            }
        }
        .success { object -> Business? in
            let result = object as? Business
            return result
        }

        return task
    }
    
    /**
        Finds the BusinessDAO based on the query.
        
        :params: query A PFQuery.
        :returns: A Task which contains an array of BusinessDTO.
    */
    public func findBy(var query: PFQuery?) -> Task<Int, [Business], NSError> {
        
        if query == nil {
            query = Business.query()
        }
        
        let task = Task<Int, [AnyObject], NSError> { progress, fulfill, reject, configure in
            self.enhanceQuery(&query!)
            query?.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
                if error == nil {
                    fulfill(objects!)
                }
                else {
                    reject(error!)
                }
            }
        }
        .success { (objects: [AnyObject]) -> [Business] in
            let businesses = objects as! [Business]
            return businesses
        }
        
        return task
    }
    
    private func enhanceQuery(inout query: PFQuery) {
        
    }
    
    
}

// geolocation service
extension BusinessService {
    /**
    This function translate physical address to geolocation coordinates.
    
    :params: address A String of the address.
    :returns: a Task containing a GeoPointEntity which contains the location data.
    */
    private func forwardGeocoding(address: String) -> Task<Int, PFGeoPoint, NSError> {
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
            .success { (placemarks: [AnyObject]) -> PFGeoPoint in
                // convert to GeoPointEntity
                let placemark = placemarks[0] as! CLPlacemark
                let location = placemark.location
                let geopoint = PFGeoPoint(location: location)
                
                return geopoint
        }
        return task
    }
}