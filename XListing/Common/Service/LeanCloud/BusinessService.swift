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
import AVOSCloud

public struct BusinessService : IBusinessService {
    
    
    /**
        This function finds the BusinessDAO based on the query.

        :params: query A PFQuery.
        :returns: a Task containing the result DAO in optional.
    */
    public func getFirst(var query: AVQuery?) -> Task<Int, Business?, NSError> {
        if query == nil {
            query = Business.query()
        }
        
        let task = Task<Int, AVObject, NSError> { progress, fulfill, reject, configure in
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
    public func findBy(var query: AVQuery?) -> Task<Int, [Business], NSError> {
        
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
    
    private func enhanceQuery(inout query: AVQuery) {
        
    }
    
    
}