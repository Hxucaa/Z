//
//  BusinessSpec.swift
//  XListing
//
//  Created by Lance Zhu on 2015-03-06.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Quick
import Nimble
import XListing

class BusinessSpec: QuickSpec {
    override func spec() {
        describe("Save") {
            var business: Business!
            
            beforeEach {
                business = Business()
                
                var location = Location()
                location.address = ["3289 Alberta st."]
                location.city = "Vancouver"
                location.countryCode = "CA"
                location.stateCode = "BC"
                
                business.name = "test business 2"
                business.isClaimed = true
                business.isClosed = false
                business.imageUrl = "placeholder"
                business.url = "placeholder"
                business.mobileUrl = "placeholder"
                business.phone = "6049872738"
                business.location = location
            }
            
            afterEach {
                var r = business.delete()
            }
            
            it("should save to Parse correctly") {
                waitUntil(timeout: 3) { done in
                    business.saveInBackgroundWithBlock({(success: Bool , error: NSError!) -> Void in
                        expect(success).to(beTrue())
                        done()
                    })
                }
                
                let query = Business.query()
                query.whereKey("objectId", equalTo: business.objectId)
                query.includeKey("location")
                
                waitUntil(timeout: 3) { done in
                    query.findObjectsInBackgroundWithBlock({(objects: [AnyObject]!, error: NSError!) -> Void in
                        expect(error).to(beNil())
                        expect(objects.count).to(equal(1))
                        
                        let obj = objects.first as Business
                        
                        expect(obj.name!).to(equal(business.name!))
                        expect(obj.isClaimed!).to(equal(business.isClaimed!))
                        expect(obj.isClosed!).to(equal(business.isClosed!))
                        expect(obj.imageUrl!).to(equal(business.imageUrl!))
                        expect(obj.url!).to(equal(business.url!))
                        expect(obj.mobileUrl!).to(equal(business.mobileUrl!))
                        expect(obj.phone!).to(equal(business.phone!))
                        expect((obj.location?.address)!).to(equal((business.location?.address)!))
                        expect((obj.location?.city)!).to(equal((business.location?.city)!))
                        expect((obj.location?.countryCode)!).to(equal((business.location?.countryCode)!))
                        expect((obj.location?.stateCode)!).to(equal((business.location?.stateCode)!))
                        
                        done()
                    })
                }
            }
        }
    }
}
