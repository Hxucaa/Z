//
//  WantToGoService.swift
//  XListing
//
//  Created by Lance Zhu on 2015-04-29.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
import SwiftTask

public class WantToGoService : ObjectService, IWantToGoService {
    public func findBy(var query: PFQuery?) -> Task<Int, [WantToGoDAO], NSError> {
        if query == nil {
            query = WantToGoDAO.query()
        }
        
        return super.findBy(query).success { objects -> [WantToGoDAO] in
            return objects as! [WantToGoDAO]
        }
    }
    
    public func goingToBusiness(businessId: String, thisWeek: Bool, thisMonth: Bool, later: Bool) -> Task<Int, WantToGoDAO, NSError> {
        
        return Task<Int, AnyObject, NSError> { progress, fulfill, reject, configure in
            PFCloud.callFunctionInBackground("wantToGo", withParameters: ["thisWeek": thisWeek, "thisMonth": thisMonth, "later": later, "interestedInBusinessId": businessId]) { (result, error) -> Void in
                if error == nil {
                    fulfill(result!)
                }
                else {
                    reject(error!)
                }
            }
        }
        .success { object -> WantToGoDAO in
            return object as! WantToGoDAO
        }
    }
}
