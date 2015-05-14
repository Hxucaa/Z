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
    public func findBy(var query: PFQuery?) -> Task<Int, [WantToGo], NSError> {
        if query == nil {
            query = WantToGo.query()
        }
        
        return super.findBy(query).success { objects -> [WantToGo] in
            return objects as! [WantToGo]
        }
    }
    
    public func goingToBusiness(businessId: String, thisWeek: Bool, thisMonth: Bool, later: Bool) -> Task<Int, WantToGo, NSError> {
        
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
        .success { object -> WantToGo in
            return object as! WantToGo
        }
    }
}
