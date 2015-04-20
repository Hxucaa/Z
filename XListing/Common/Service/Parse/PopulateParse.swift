//
//  PopulateParse.swift
//  XListing
//
//  Created by Lance Zhu on 2015-03-07.
//  Copyright (c) 2015 ZenChat. All rights reserved.
//

import Foundation
//import SwiftyJSON
import SwiftTask
//import Dollar

public class PopulateParse {
    
    private let userService: IUserService = UserService()
    private let objectService: IObjectService = ObjectService()
    private typealias TaskList = (name: String, tasks: [SaveTask])
    
    public init() {
        
    }
    
    public func populate() {
        var userAndRoleTasks: TaskList = ("User and Role",
            [
                createRole("User"),
                createRole("Business User"),
                createRole("Curator"),
                createRole("Administrator"),
                createUser(),
                createUser(),
                createUser(),
                createUser()
            ]
        )
        
        var roleHierarchyTasks: TaskList = ("Role Hierarchy",
            [
                roleHierarchy(parentRole: "User", childRole: "Business User"),
                roleHierarchy(parentRole: "Business User", childRole: "Curator"),
                roleHierarchy(parentRole: "Curator", childRole: "Administrator"),
            ]
        )
        
        self.runArrayOfTasksInParallel(userAndRoleTasks)
            .success {
                self.runArrayOfTasksInParallel(roleHierarchyTasks)
            }
    }
    
    private func runArrayOfTasksInParallel(tasklist: TaskList) -> Task<SwiftTask.Task.BulkProgress, Void, NSError> {
        let tasks = tasklist.tasks
        let taskName = tasklist.name
        
        println("Uploading \(taskName) starts: ")
        
        return Task.all(tasks)
            .progress { oldProgress, newProgress in
                println("Progress: \(newProgress.completedCount)/\(newProgress.totalCount)")
            }
            .success { successArr -> Void in
                println("Uploading \(taskName) to server completes successfully!\n")
            }
            .failure { error, isCancelled -> Void in
                if let error = error {
                    println("Error: \(error.localizedDescription)")
                }
                if isCancelled {
                    println("Tasks \(taskName) cancelled!")
                }
            }
    }
    
    private func createUser() -> SaveTask {
        let user = UserDAO()
        user.username = NSUUID().UUIDString
        user.password = "12345678"
        user.name = "test user"
        
        return userService.signUp(user)
    }
    
    private func createRole(typeOfRole: String) -> SaveTask {
        let roleACL = PFACL()
        roleACL.setPublicReadAccess(true)
        roleACL.setPublicWriteAccess(true)
        let role = PFRole(name: typeOfRole, acl: roleACL)
        return objectService.save(role)
    }
    
    private func roleHierarchy(#parentRole: String, childRole: String) -> SaveTask {
        let parentRoleQuery = PFRole.queryWithPredicate(NSPredicate(format: "name=%@", parentRole))
        let childRoleQuery = PFRole.queryWithPredicate(NSPredicate(format: "name=%@", childRole))
        return objectService.getFirst(parentRoleQuery)
            .success { parentRole -> PFRole in
                return parentRole as! PFRole
            }
            .success { parentRole -> Task<Int, (PFRole, PFRole), NSError> in
                return self.objectService.getFirst(childRoleQuery).success { childRole -> (PFRole, PFRole) in
                    return (parentRole, childRole as! PFRole)
                }
            }
            .success { (parentRole, childRole) -> SaveTask in
                parentRole.roles.addObject(childRole)
                return self.objectService.save(parentRole)
            }
    }
    
    
//    private typealias SaveTask = Task<Int, Bool, NSError>
//    private let businessInteractor = BusinessInteractor(businessDataManager: BusinessDataManager(), geolocationDataManager: GeolocationDataManager())
//
//    public func populate() {
//        populateFromJSON()
//        
//    }
//    
//    public func featuredizeByNameSChinese(name: String) {
//        // create a task to find the business first
//        let q = BusinessEntity.query()
//        q.whereKey("nameSChinese", equalTo: name)
//        let queryTask = businessInteractor.findBusinessBy(q)
//        
//        
//        // create a task to save to the cloud
//        let saveTask = queryTask
//            .success { businessDomain -> SaveTask in
//                if businessDomain.count > 1 {
//                    fatalError("Found multiple records!")
//                }
//                
//                // create a new BusinessDomain to update the business
//                let updatedBusinessDomain = BusinessDomain()
//                updatedBusinessDomain.objectId = businessDomain.first?.objectId
//                updatedBusinessDomain.featured = true
//                updatedBusinessDomain.timeStart = NSDate()
//                updatedBusinessDomain.timeEnd = NSDate()
//                
//                return self.businessInteractor.saveBusiness(updatedBusinessDomain)
//            }
//        
//        // process save tasks
//        processAllSaveTasks([saveTask])
//    }
//    
//    private func populateFromJSON() {
//        var businessEntityArr = loadBusinessesFromJSON("localBizInfo", ofType: "json")
//        
//        // launch all tasks
//        let uploadTasks = businessEntityArr.map { (business: BusinessDomain) -> SaveTask in
//            
//            return self.businessInteractor.saveBusiness(business)
//        }
//        
//        processAllSaveTasks(uploadTasks)
//        
//    }
//    
//    ///
//    /// Process every save task.
//    ///
//    private func processAllSaveTasks(tasks: [SaveTask]) {
//        // ensure all upload tasks are successful
//        Task
//            .all(tasks)
//            .progress { (oldProgress, newProgress) -> Void in
//                println("Progress: \(newProgress.completedCount)/\(newProgress.totalCount)")
//                return
//            }
//            .success { successes -> Void in
//                if $.every(successes, callback: { $0 }) && successes.count == tasks.count {
//                    println("Upload data to server completes successfully!")
//                }
//                else {
//                    println("Upload fails!")
//                }
//            }
//            .failure { (error, isCancelled) -> Void in
//                if let error = error {
//                    println("Error: \(error.localizedDescription)")
//                }
//                if isCancelled {
//                    println("Tasks cancelled!")
//                }
//        }
//    }
//    
//    ///
//    /// Load data from JSON file
//    ///
//    private func loadBusinessesFromJSON(filename: String, ofType: String) -> [BusinessDomain] {
//        let path = NSBundle.mainBundle().pathForResource(filename, ofType: ofType)
//        let jsonData = NSData(contentsOfFile: path!, options: .DataReadingMappedIfSafe, error: nil)
//        let json = JSON(data: jsonData!)
//        var businessDomainArr = [BusinessDomain]()
//        
//        for(index: String, subJson: JSON) in json {
//            var b = BusinessDomain()
//            
//            if let name = subJson["nameSChinese"].string {
//                b.nameSChinese = name
//            }
//            if let name = subJson["nameTChinese"].string {
//                b.nameTChinese = name
//            }
//            if let name = subJson["nameEnglish"].string {
//                b.nameEnglish = name
//            }
//            if let isClaimed = subJson["isClaimed"].bool {
//                b.isClaimed = isClaimed
//            }
//            if let isClosed = subJson["isClosed"].bool {
//                b.isClosed = isClosed
//            }
//            if let phone = subJson["phone"].string {
//                b.phone = phone
//            }
//            if let url = subJson["url"].string {
//                b.url = url
//            }
//            if let mobileUrl = subJson["mobileUrl"].string {
//                b.mobileUrl = mobileUrl
//            }
//            if let uid = subJson["uid"].string {
//                b.uid = uid
//            }
//            if let imageUrl = subJson["imageUrl"].string {
//                b.imageUrl = imageUrl
//            }
//            if let reviewCount = subJson["reviewCount"].int {
//                b.reviewCount = reviewCount
//            }
//            if let rating = subJson["rating"].double {
//                b.rating = rating
//            }
//            if let unit = subJson["unit"].string {
//                b.unit = unit
//            }
//            if let address = subJson["address"].string {
//                b.address = address
//            }
//            if let district = subJson["district"].string {
//                b.district = district
//            }
//            if let city = subJson["city"].string {
//                b.city = city
//            }
//            if let state = subJson["state"].string {
//                b.state = state
//            }
//            if let country = subJson["country"].string {
//                b.country = country
//            }
//            if let postalCode = subJson["postalCode"].string {
//                b.postalCode = postalCode
//            }
//            if let crossStreets = subJson["crossStreets"].string {
//                b.crossStreets = crossStreets
//            }
//            
//            businessDomainArr.append(b)
//        }
//        return businessDomainArr
//    }
}