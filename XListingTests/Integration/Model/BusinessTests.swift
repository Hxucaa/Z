//
//  BusinessTests.swift
//  XListing
//
//  Created by Lance Zhu on 2015-03-03.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import XCTest
import XListing

class BusinessTests: XCTestCase {
    var business: BusinessEntity = BusinessEntity()
    
    override func setUp() {
        super.setUp()
        
        var location = LocationEntity()
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
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        business.delete()
        super.tearDown()
    }
    
    func testSave() {
        //        XCTAssert(business.save(), "Pass")
        let objectSent = expectationWithDescription("Business object is sent")
        business.saveInBackgroundWithBlock({(success: Bool , error: NSError!) -> Void in
            objectSent.fulfill()
            XCTAssert(success, "Pass")
        })
        
        waitForExpectationsWithTimeout(5, handler: {(error) in
            
        })
        
        
        let objectSaved = expectationWithDescription("Business object is saved")
        let query = BusinessEntity.query()
        query.whereKey("objectId", equalTo: business.objectId)
        query.includeKey("location")
        query.findObjectsInBackgroundWithBlock({(objects: [AnyObject]!, error: NSError!) -> Void in
            objectSaved.fulfill()
            XCTAssertNil(error, "No error message")
            XCTAssertEqual(objects.count, 1, "size is 1")
            
            let obj = objects.first as BusinessEntity
            
            XCTAssertEqual(obj.name!, self.business.name!, "Same name")
            XCTAssertEqual(obj.isClaimed!, self.business.isClaimed!, "Same")
            XCTAssertEqual(obj.isClosed!, self.business.isClosed!, "Same")
            XCTAssertEqual(obj.imageUrl!, self.business.imageUrl!, "Same")
            XCTAssertEqual(obj.url!, self.business.url!, "Same")
            XCTAssertEqual(obj.mobileUrl!, self.business.mobileUrl!, "Same")
            XCTAssertEqual(obj.phone!, self.business.phone!, "Same")
            XCTAssertEqual((obj.location?.address)!, (self.business.location?.address)!, "Same")
            XCTAssertEqual((obj.location?.city)!, (self.business.location?.city)!, "Same")
            XCTAssertEqual((obj.location?.countryCode)!, (self.business.location?.countryCode)!, "Same")
            XCTAssertEqual((obj.location?.stateCode)!, (self.business.location?.stateCode)!, "Same")

        })
        
        waitForExpectationsWithTimeout(5, handler: {(error) in
            
        })
    }
}